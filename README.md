# cap_tags

**One capability bit from GBT V8, packaged standalone.** No. 249 of 341,
`system` domain (System).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> GBT 技能标签 + 主人调用许可（主人令「将所有的原生能力注册出专属的 GBT 技能标签，只有我允许了才能调用我的能力」）：每个能力位一个稳定标签 `GBT-<域>-<能力位>`，**从注册表现算**；权限类**由框架自己的判据推**（`policy.evaluate` 逐 op 问作用域 + 图鉴 safe/needs_confirmation），**读不出来一律按 owner**（默认严）。`owner` 类=只有主人发许可才能调；许可在 `gbt_allinone/store/owner_permits.jsonl`，**本能力没有任何写它的路径**，终端 `permit` 命令要求 TTY + 手打 YES ⇒ **AI 发不出许可**。op=tags/check/permits/how/audit/verify/where/permit

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-cap-tags.git
cd gbt-cap-tags
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_cap_tags info                  # capability card
python -m gbt_cap_tags spec --json           # machine-readable contract
python -m gbt_cap_tags check --payload '{}'
python -m gbt_cap_tags run   --payload '{}'
```

Real `info` output from this machine:

```text
cap_tags  (system)  v1.0.0
----------------------------------------
GBT 技能标签 + 主人调用许可（主人令「将所有的原生能力注册出专属的 GBT 技能标签，只有我允许了才能调用我的能力」）：每个能力位一个稳定标签 `GBT-<域>-<能力位>`，**从注册表现算**；权限类**由框架自己的判据推**（`policy.evaluate` 逐 op 问作用域 + 图鉴 safe/needs_confirmation），**读不出来一律按 owner**（默认严）。`owner` 类=只有主人发许可才能调；许可在 `gbt_allinone/store/owner_permits.jsonl`，**本能力没有任何写它的路径**，终端 `permit` 命令要求 TTY + 手打 YES ⇒ **AI 发不出许可**。op=tags/check/permits/how/audit/verify/where/permit

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : gbt_allinone, store, owner_permits
```

Wire a real implementation:

```python
from gbt_cap_tags import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（3 个）**：`gbt_allinone`、`store`、`owner_permits`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.17s
```

## Provenance

| field | value |
|---|---|
| capability | `cap_tags` |
| domain | `system` |
| handler | `cap_tags` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [system/cap_tags](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/system/cap_tags.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
