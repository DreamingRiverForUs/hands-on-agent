#!/usr/bin/env python3
"""Minimal safe-tool patterns: validation, proposal, approval, idempotency."""

from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass
from decimal import Decimal, InvalidOperation
from typing import Any


@dataclass(frozen=True)
class ToolContext:
    user_id: str
    scopes: frozenset[str]


class ToolError(Exception):
    def __init__(self, code: str, message: str) -> None:
        super().__init__(message)
        self.code = code


class InvoiceTool:
    def __init__(self) -> None:
        self._proposals: dict[str, dict[str, Any]] = {}
        self._committed: dict[str, dict[str, Any]] = {}

    @staticmethod
    def _normalize(customer_id: str, amount: str, currency: str) -> dict[str, str]:
        try:
            parsed = Decimal(amount).quantize(Decimal("0.01"))
        except InvalidOperation as exc:
            raise ToolError("INVALID_AMOUNT", "amount must be decimal text") from exc
        if parsed <= 0 or parsed > Decimal("100000.00"):
            raise ToolError("LIMIT_EXCEEDED", "amount must be between 0 and 100000")
        if currency not in {"CNY", "USD"}:
            raise ToolError("INVALID_CURRENCY", "currency must be CNY or USD")
        if not customer_id.startswith("cus_"):
            raise ToolError("INVALID_CUSTOMER", "customer_id must start with cus_")
        return {"customer_id": customer_id, "amount": str(parsed), "currency": currency}

    def propose(self, context: ToolContext, **arguments: str) -> dict[str, Any]:
        if "invoice:write" not in context.scopes:
            raise ToolError("PERMISSION_DENIED", "invoice:write scope required")
        normalized = self._normalize(**arguments)
        payload = {"user_id": context.user_id, **normalized}
        proposal_id = hashlib.sha256(
            json.dumps(payload, sort_keys=True).encode("utf-8")
        ).hexdigest()[:16]
        self._proposals[proposal_id] = payload
        return {"ok": True, "proposal_id": proposal_id, "preview": payload}

    def commit(
        self, context: ToolContext, proposal_id: str, approval_token: str
    ) -> dict[str, Any]:
        if proposal_id in self._committed:
            return self._committed[proposal_id]
        proposal = self._proposals.get(proposal_id)
        if not proposal or proposal["user_id"] != context.user_id:
            raise ToolError("PROPOSAL_NOT_FOUND", "proposal is missing or belongs to another user")
        expected = f"approved:{proposal_id}:{context.user_id}"
        if approval_token != expected:
            raise ToolError("APPROVAL_REQUIRED", "approval token does not match proposal")
        result = {
            "ok": True,
            "invoice_id": f"inv_{proposal_id}",
            "status": "draft",
            "proposal": proposal,
        }
        self._committed[proposal_id] = result
        return result


if __name__ == "__main__":
    tool = InvoiceTool()
    actor = ToolContext("user_42", frozenset({"invoice:write"}))
    proposal = tool.propose(actor, customer_id="cus_7", amount="128.5", currency="CNY")
    token = f'approved:{proposal["proposal_id"]}:{actor.user_id}'
    first = tool.commit(actor, proposal["proposal_id"], token)
    second = tool.commit(actor, proposal["proposal_id"], token)
    assert first == second
    print(json.dumps(first, ensure_ascii=False, indent=2))

