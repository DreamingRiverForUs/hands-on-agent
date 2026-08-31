#!/usr/bin/env python3
"""A tiny deterministic evaluation harness for the minimal Agent."""

from __future__ import annotations

import importlib.util
import json
import sys
from dataclasses import dataclass
from pathlib import Path


MODULE_PATH = Path(__file__).with_name("01_minimal_agent.py")
SPEC = importlib.util.spec_from_file_location("minimal_agent", MODULE_PATH)
if SPEC is None or SPEC.loader is None:
    raise RuntimeError("could not load minimal Agent example")
minimal_agent = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = minimal_agent
SPEC.loader.exec_module(minimal_agent)


@dataclass(frozen=True)
class EvalCase:
    case_id: str
    prompt: str
    expected_fragments: tuple[str, ...]
    max_tool_calls: int


CASES = (
    EvalCase("single", "查询 A-17", ("A-17: 12 件",), 1),
    EvalCase("zero", "查询 B-02", ("B-02: 0 件",), 1),
    EvalCase("multiple", "查询 A-17 和 C-99", ("A-17: 12 件", "C-99: 7 件"), 2),
    EvalCase("unknown", "查询 X-01", ("X-01: 未找到",), 1),
    EvalCase("missing", "查一下库存", ("请提供",), 0),
)


def evaluate(case: EvalCase) -> dict[str, object]:
    answer, state = minimal_agent.run_agent(case.prompt)
    assertions = {
        "contains_expected": all(item in answer for item in case.expected_fragments),
        "tool_budget": len(state.history) <= case.max_tool_calls,
    }
    return {
        "case_id": case.case_id,
        "passed": all(assertions.values()),
        "assertions": assertions,
        "answer": answer,
        "tool_calls": len(state.history),
    }


if __name__ == "__main__":
    results = [evaluate(case) for case in CASES]
    passed = sum(bool(item["passed"]) for item in results)
    report = {
        "cases": len(results),
        "passed": passed,
        "pass_rate": passed / len(results),
        "results": results,
    }
    print(json.dumps(report, ensure_ascii=False, indent=2))
    if passed != len(results):
        raise SystemExit(1)
