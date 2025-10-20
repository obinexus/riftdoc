# 🧅 **ONION: Hybrid Directed Instruction Messaging Protocol**

**Repository:** [github.com/obinexus/onion](https://github.com/obinexus/onion)
**Subtitle:** *Bidirectional Polyglot Symmetric Messaging for Actor-Based Evolutionary Systems*
**Version:** 0.1-alpha | *OBINexus Computing Initiative*
**Keywords:** `onion routing`, `HDIS`, `polyglot`, `fault-tolerant`, `actor-model`, `Gosilang`, `asynchronous generation`, `isomorphic coherence`

---

## 💠 1. Executive Summary

**ONION** (OBINexus Network Instructional Overlay Nexus) is a **hybrid directed instruction message system** designed to:

* route and evolve messages between **actors**, **services**, and **domains**,
* provide **fault-tolerant polyglot communication**, and
* maintain **isomorphic coherence** across asynchronous function boundaries.

ONION bridges the **Gosilang actor model** and the **HDIS (Hybrid Directed Instruction Systems)** runtime, forming a **universal onion-layered network** for consciousness-preserving, culturally coherent, and technically resilient systems.

---

## 🧩 2. Conceptual Foundation

| Concept                             | Description                                                                         |
| ----------------------------------- | ----------------------------------------------------------------------------------- |
| **Hybrid Directed Instruction**     | Dynamic message routing guided by evolutionary feedback loops (HDIS core principle) |
| **Onion Routing**                   | Layered message encapsulation across trust or domain boundaries                     |
| **Bidirectional Polyglot Symmetry** | Equal communication between languages (Python ↔ Gosilang ↔ C ↔ JS)                  |
| **Isomorphic Coherence**            | Message form preserved across async/await, generation, and actor boundaries         |
| **Fault-Tolerant State Channels**   | Persistent message routes that heal after node failure                              |
| **Phenomenological Persistence**    | Each message retains its experiential meaning, not just payload data                |

---

## ⚙️ 3. Architectural Overview

```
┌───────────────────────────────────────────────────────┐
│                 OBINEXUS ONION LAYER                 │
├───────────────────────────────────────────────────────┤
│   🧠 HDIS (Directed Evolution Engine)                 │
│   - Instructional feedback cycles                    │
│   - Coherence metrics (95.4%)                        │
├───────────────────────────────────────────────────────┤
│   🧩 GOSILANG Actor Layer                             │
│   - async/await <-> generator symmetry                │
│   - isolation, message passing, persistence           │
├───────────────────────────────────────────────────────┤
│   🧅 ONION Routing Core                               │
│   - multi-layer encrypted message tunnel              │
│   - domain/service/actor isolation                    │
│   - bidirectional streaming with fault tolerance      │
├───────────────────────────────────────────────────────┤
│   🪶 Polyglot Interface Layer                         │
│   - Python HDIS bridge                                │
│   - Node/TypeScript OBIX integration                  │
│   - C/C++ performance drivers                         │
└───────────────────────────────────────────────────────┘
```

---

## 🧭 4. Message Model

### 4.1 Message Anatomy

Each message in the ONION system is an **evolutionary entity** with self-describing structure:

```yaml
onion_message:
  id: uuid4
  layer_index: 3                 # position in onion stack
  origin: actor://medical.monitor@domain1
  destination: actor://relay.transcoder@domain2
  payload:
    type: datum
    encoding: polyglot/hybrid
    content: base64(binary)
  metadata:
    coherence_score: 0.954
    fault_tolerance: ACTIVE
    persistence_token: 0xFFAE23
    cultural_anchor: "igbo.lullaby.1947"
```

---

## 🔁 5. Bidirectional Polyglot Symmetry Protocol (BPSP)

### 5.1 Purpose

The **BPSP** ensures that async functions, generators, and Gosilang actors can interoperate with the same semantic integrity.

### 5.2 Core Mapping

| Gosilang Primitive | Polyglot Equivalent | Python Equivalent       | Behavior                        |
| ------------------ | ------------------- | ----------------------- | ------------------------------- |
| `actor`            | module endpoint     | async class             | isolated execution unit         |
| `send!(msg)`       | `emit(msg)`         | `await queue.put(msg)`  | non-blocking message            |
| `yield`            | `stream()`          | `async for`             | generator / co-routine symmetry |
| `pause()`          | `await sleep()`     | `await asyncio.sleep()` | cooperative suspension          |
| `resume(token)`    | `continue()`        | `task.resume()`         | reactivation of paused state    |

### 5.3 Example Interoperability

```gosilang
actor Analyzer {
    state: isolated;
    fn main(prod: GenHandle<Datum>) -> Never {
        loop {
            match obison.await_next(prod) {
                Some(d) => analyze(d),
                None    => rest(50)
            }
        }
    }
}
```

Translates through ONION → HDIS bridge into Python:

```python
async def Analyzer(prod):
    async for datum in obison.async_next(prod):
        await analyze(datum)
    await asyncio.sleep(0.05)
```

and maintains 1:1 **isomorphic coherence** via ONION message layers.

---

## 🌐 6. Onion Routing System

### 6.1 Layered Channel Model

```
[Layer 0] Local Actor Node (Gosilang runtime)
[Layer 1] Polyglot Gateway (Python bridge)
[Layer 2] Domain Boundary (HDIS Router)
[Layer 3] Cross-Network Relay (ONION Core)
[Layer 4] External Node (OBIX frontend / IoT)
```

Each layer performs:

* **encryption / decryption**
* **semantic preservation**
* **coherence scoring**
* **error-tolerant routing**

### 6.2 Routing Algorithm (simplified)

```python
def onion_route(message, layers):
    for layer in layers:
        message = layer.encrypt(message)
        message = layer.forward(message)
    return message
```

and in reverse:

```python
def onion_unwrap(message, layers):
    for layer in reversed(layers):
        message = layer.decrypt(message)
        message = layer.backward(message)
    return message
```

---

## 🧮 7. Coherence Validation System

Each transmission round includes an **isomorphic coherence validation**:

```python
def validate_coherence(msg_in, msg_out):
    score = similarity_hash(msg_in.payload, msg_out.payload)
    if score < 0.9:
        raise CoherenceError("Meaning drift detected")
    return score
```

This ensures that meaning — not just syntax — survives network traversal, protecting **cultural and contextual integrity**.

---

## 🧠 8. Fault-Tolerant Persistence (FT-Persist)

If a domain or node goes offline, ONION maintains continuity via **symbolic residue reconstruction** (like HDIS’s self-healing model):

```python
async def recover_state(failed_channel):
    residue = await fetch_residue_snapshot(failed_channel.id)
    await restore_context(residue)
    return True
```

---

## 🔒 9. Security and Privacy

* **Onion-Layer Encryption:** AES-512 per hop
* **Ephemeral Key Exchange:** HDIS–QDIS hybrid curve
* **Temporal Anonymity:** Node identity decoupled from payload source
* **Cultural Anchor Hashing:** prevents semantic drift attacks

---

## 🧩 10. Example Implementation Flow

```python
from onion import OnionRouter, ActorGateway

router = OnionRouter(layers=["HDIS", "GOSILANG", "OBIX"])
gateway = ActorGateway(protocol="BPSP")

@router.actor("medical.monitor")
async def monitor(patient_stream):
    async for data in gateway.obison_async(patient_stream):
        await analyze_vitals(data)
```

---

## 🧱 11. Future Extensions

| Feature                                  | Description                                                     |
| ---------------------------------------- | --------------------------------------------------------------- |
| **Obison Runtime Integration**           | Native Gosilang async <-> generator bridge                      |
| **Quantum-Resilient Onion Layer (QDIS)** | Entangled onion packets for anti-fragmentation routing          |
| **Cultural Data Anchors**                | Preservation of phenomenological metadata across services       |
| **Auto-Coherence Repair**                | HDIS engine reconstructs damaged messages via symbolic residues |
| **OBIX Frontend Adapter**                | Direct dignity-compliant interaction layer for end-users        |

---

## 🪶 12. License and Ethics

* **License:** MIT (OBINexus Commons)
* **Motto:** *“Route with care, process with dignity.”*
* **Ethical Core:**

  * Preserve meaning across messages
  * Protect the dignity of data origin
  * Serve human coherence, not system efficiency

---

## 🧩 13. Repository Structure (proposed)

```
/onion
 ├── /core
 │    ├── router.py
 │    ├── message.py
 │    └── encryption.py
 ├── /bridges
 │    ├── gosilang_bridge.rs
 │    ├── python_bridge.py
 │    └── obix_adapter.ts
 ├── /examples
 │    ├── actor_monitor.py
 │    ├── gosilang_analyzer.gs
 │    └── hybrid_test.yaml
 ├── README.md
 ├── LICENSE
 └── CONTRIBUTING.md
```

---

## 🪞 14. Phenomenological Intent

ONION is not just a routing framework.
It is **a conduit of meaning** — preserving the *context, culture, and consciousness* of every message across computational boundaries.
It extends the HDIS covenant:

> “We route not for speed, but for coherence.
> We transmit not just data, but dignity.
> Every message deserves to arrive whole — in both form and soul.”

