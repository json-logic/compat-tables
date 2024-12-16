# Test Results Comparison

### Status Key
- ✅ All tests passing
- ⚠️ Some tests failing
- ❌ Not supported/Not implemented

Results format: passed/total scenarios

| library                                                                                | version            | Compound Tests   | Data-Driven   | Non-rules get passed through   | Single operator tests   |
|:---------------------------------------------------------------------------------------|:-------------------|:-----------------|:--------------|:-------------------------------|:------------------------|
| **[datalogic-rs](https://github.com/Open-Payments/datalogic-rs) Rust**                 | 1.0.8 (2024-12-10) | 5/5 ✅            | 88/88 ✅       | 7/7 ✅                          | 178/178 ✅               |
| **[json-logic-engine](https://github.com/TotalTechGeek/json-logic-engine) JavaScript** | 4.0.2 (2024-12-13) | 5/5 ✅            | 88/88 ✅       | 7/7 ✅                          | 178/178 ✅               |
| **[json-logic-js](https://github.com/jwadhams/json-logic-js) JavaScript**              | 2.0.5 (2024-07-09) | 5/5 ✅            | 88/88 ✅       | 7/7 ✅                          | 178/178 ✅               |
| **[jsonlogic](https://github.com/marvindv/jsonlogic_rs) Rust**                         | 0.5.1 (2020-03-05) | 4/5 ⚠️           | 79/88 ⚠️      | 7/7 ✅                          | 150/178 ⚠️              |
| **[jsonlogic-rs](https://github.com/Bestowinc/json-logic-rs) Rust**                    | 0.4.0 (2024-07-01) | 5/5 ✅            | 88/88 ✅       | 7/7 ✅                          | 176/178 ⚠️              |