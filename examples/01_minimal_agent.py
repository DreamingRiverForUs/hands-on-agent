#!/usr/bin/env python3
"""A deterministic, dependency-free Agent loop for teaching and CI."""

from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from typing import Any, Callable


INVENTORY = {"A-17": 12, "B-02": 0, "C-99": 7}


@dataclass
class AgentState:
    goal: str
    max_steps: int = 8
    history: list[dict[str, Any]] = field(default_factory=list)


def lookup_stock(sku: str) -> dict[str, Any]:
    sku = sku.upper()
    if sku not in INVENTORY:
        return {"ok": False, "error": "SKU_NOT_FOUND", "sku": sku}
    return {"ok": True, "sku": sku, "quantity": INVENTORY[sku]}


TOOLS: dict[str, Callable[..., dict[str, Any]]] = {"lookup_stock": lookup_stock}


def decide(state: AgentState) -> dict[str, Any]:
    """Simulate a model while preserving the same structured-action boundary."""
    requested = list(dict.fromkeys(re.findall(r"[A-Za-z]-\d{2}", state.goal.upper())))
    observed = {
        item["observation"]["sku"]
        for item in state.history
        if item["observation"].get("sku")
    }

    for sku in requested:
        if sku not in observed:
            return {
                "type": "tool",
                "name": "lookup_stock",
                "arguments": {"sku": sku},
            }

    if not requested:
        return {"type": "final", "answer": "请提供形如 A-17 的商品编号。"}

    facts = []
    for item in state.history:
        result = item["observation"]
        if result.get("ok"):
            facts.append(f'{result["sku"]}: {result["quantity"]} 件')
        else:
            facts.append(f'{result["sku"]}: 未找到')
    return {"type": "final", "answer": "；".join(facts)}


def validate_action(action: dict[str, Any]) -> None:
    if action.get("type") == "final":
        if not isinstance(action.get("answer"), str):
            raise ValueError("final action requires a string answer")
        return
    if action.get("type") != "tool":
        raise ValueError("action type must be tool or final")
    if action.get("name") not in TOOLS:
        raise ValueError("unknown tool")
    arguments = action.get("arguments")
    if not isinstance(arguments, dict) or not isinstance(arguments.get("sku"), str):
        raise ValueError("lookup_stock requires string sku")


def run_agent(goal: str, max_steps: int = 8) -> tuple[str, AgentState]:
    state = AgentState(goal=goal, max_steps=max_steps)
    for step in range(max_steps):
        action = decide(state)
        validate_action(action)
        if action["type"] == "final":
            return action["answer"], state
        observation = TOOLS[action["name"]](**action["arguments"])
        state.history.append(
            {"step": step + 1, "action": action, "observation": observation}
        )
    raise RuntimeError(f"step limit exceeded: {max_steps}")


if __name__ == "__main__":
    answer, final_state = run_agent("查询 A-17、B-02 和 X-01 的库存")
    print(answer)
    print(json.dumps(final_state.history, ensure_ascii=False, indent=2))

