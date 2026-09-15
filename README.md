# Overall architecture:

```mermaid
flowchart TB
    subgraph Device["DEVICE"]
        A[AGENT<br/>LangChain]
        P[POLICY<br/>Python]
    end

    subgraph Backend["BACKEND"]
        O[ORGANIZATION<br/>LangGraph]
        C[(CHAIN<br/>Ledger)]
    end

    subgraph ML["LEARNING"]
        F[FLOWER]
    end

    A -->|propose| P
    P -->|dispatch| O
    O -->|outcome| P
    O -->|settle| C
    P -->|persist| C
    C -->|events| F
    F -.->|params| A

    style A fill:#e1f5ff
    style P fill:#fff4e1
    style O fill:#e8f5e9
    style C fill:#fce4ec
    style F fill:#f3e5f5
```

# Flow

```mermaid
flowchart LR
    S1[1. Agent<br/>propose] --> S2[2. Policy<br/>validate]
    S2 --> S3[3. Organization<br/>execute]
    S3 --> S4[4. Verdict<br/>decision]
    S4 --> S5[5. Policy<br/>settle score]
    S5 --> S6[6. Chain<br/>record]
    S6 --> S7[7. Flower<br/>learn]
    S7 -.-> S1

    style S1 fill:#e1f5ff
    style S2 fill:#fff4e1
    style S3 fill:#e8f5e9
    style S4 fill:#e8f5e9
    style S5 fill:#fff4e1
    style S6 fill:#fce4ec
    style S7 fill:#f3e5f5
```

# Components

```mermaid
flowchart TB
    subgraph Agents["AGENT — 3 roles"]
        direction LR
        A1[Claimer<br/>find bugs]
        A2[Challenger<br/>counter-argue]
        A3[Voter<br/>adjudicate]
    end

    subgraph Policy["POLICY — 3 components"]
        direction LR
        P1[State<br/>score, budget]
        P2[Rules<br/>laws]
        P3[Enforcer<br/>enforce]
    end

    subgraph Org["ORGANIZATION — 3 components"]
        direction LR
        O1[State<br/>arena]
        O2[Graph<br/>flow]
        O3[Verify<br/>sandbox/vote]
    end

    subgraph Ext["INFRASTRUCTURE"]
        direction LR
        C[(Chain<br/>ledger)]
        F[Flower<br/>learning]
        I[IPFS<br/>evidence]
    end

    A1 & A2 & A3 --> P1
    P1 --> P2 --> P3
    P3 --> O1
    O1 --> O2 --> O3
    O3 --> C
    O3 --> I
    C --> F
    F -.-> A1 & A2 & A3

    style Agents fill:#e1f5ff
    style Policy fill:#fff4e1
    style Org fill:#e8f5e9
    style Ext fill:#f5f5f5
```

# Folder structure

```text
OFMIS/
├── pyproject.toml                    # Initialize project
├── README.md
├── default.nix
├── docker-compose.yml
├── .gitignore
├── .env.example                      # template for environment variables
│
├── configs/                          # configs for simulation and experiments
│   ├── default.yaml
│   ├── scenarios/
│   │   ├── honest_only.yaml
│   │   ├── with_farmers.yaml
│   │   └── with_collusion.yaml
│   └── rules.yaml                    # Policy rules (advance, clawback, etc.)
│
├── assets/
│   └── flow.drawio.png
│
├── src/
│   └── ofmis/                        # main package
│       │
│       ├── __init__.py
│       ├── config.py                 # load config from configs/
│       ├── logging.py                # structured logging setup
│       ├── errors.py                 # custom exceptions
│       │
│       ├── shared/                   # shared types & clients
│       │   ├── __init__.py
│       │   ├── types.py              # Claim, Challenge, Vote, Verdict, AgentState
│       │   ├── schemas.py            # Pydantic models for validation
│       │   └── clients/
│       │       ├── __init__.py
│       │       ├── chain.py          # blockchain client
│       │       ├── ipfs.py           # IPFS client
│       │       ├── sandbox.py        # sandbox client (Docker/E2B)
│       │       └── flower.py         # Flower client
│       │
│       ├── agent/                    # MICRO LAYER
│       │   ├── __init__.py
│       │   ├── base.py               # BaseAgent class
│       │   ├── claimer.py            # ClaimerAgent
│       │   ├── challenger.py         # ChallengerAgent
│       │   ├── voter.py              # VoterAgent
│       │   ├── tools/                # LangChain tools
│       │   │   ├── __init__.py
│       │   │   ├── scan.py           # scan_code, static analysis
│       │   │   ├── poc.py            # create_poc, verify_poc
│       │   │   ├── submit.py         # submit_claim
│       │   │   ├── challenge.py      # challenge
│       │   │   └── vote.py           # vote
│       │   ├── prompts/              # prompt templates
│       │   │   ├── __init__.py
│       │   │   ├── claimer.txt
│       │   │   ├── challenger.txt
│       │   │   └── voter.txt
│       │
│       ├── policy/                   # CONSTRAINT LAYER
│       │   ├── __init__.py
│       │   ├── state.py              # AgentState class
│       │   ├── rules.py              # Rules class (loaded from configs/rules.yaml)
│       │   ├── enforcer.py           # validate + apply logic
│       │   ├── storage.py            # persistence (cache + chain)
│       │   └── decay.py              # decay function
│       │
│       ├── organization/             # MACRO LAYER
│       │   ├── __init__.py
│       │   ├── state.py              # ArenaState (TypedDict)
│       │   ├── graph.py              # build_graph() → CompiledGraph
│       │   ├── nodes/                # LangGraph nodes
│       │   │   ├── __init__.py
│       │   │   ├── claim.py          # node_claim
│       │   │   ├── challenge.py      # node_challenge
│       │   │   ├── verify.py         # node_verify (sandbox or vote)
│       │   │   ├── settle.py         # node_settle (clawback)
│       │   │   ├── penalty.py        # node_penalty (throttle/freeze)
│       │   │   └── fl.py             # node_fl (push to Flower)
│       │   ├── routers.py            # routing functions
│       │   └── checkpointer.py       # checkpointer setup (MemorySaver/Postgres)
│       │
│       ├── learning/                 # LEARNING LAYER
│       │   ├── __init__.py
│       │   ├── client.py             # Flower client wrapper
│       │   ├── aggregation.py        # weighted aggregation
│       │   └── unlearning.py         # clawback handling
│       │
│       └── observability/            # OBSERVABILITY LAYER (optional)
│           ├── __init__.py
│           ├── tracer.py             # LangSmith wrapper
│           └── metrics.py            # custom metrics
│
├── simulation/                       # SIMULATION
│   ├── __init__.py
│   ├── runner.py                     # main simulation loop
│   ├── environment.py                # mock codebase, bugs
│   ├── agent_factory.py              # create agents by type
│   ├── strategies/                   # agent strategies
│   │   ├── __init__.py
│   │   ├── honest.py
│   │   ├── farmer.py
│   │   ├── lazy.py
│   │   └── adversarial.py
│   └── metrics.py                    # metrics collection
│
├── scripts/                          # entry points
│   ├── run_simulation.py             # run a single simulation
│   ├── run_experiment.py             # run batch experiments
│   ├── deploy_chain.py               # deploy local chain
│   ├── pull_models.py                # pull Ollama models
│   └── analyze_results.py            # analyze results
│
├── tests/                            # UNIT TESTS
│   ├── __init__.py
│   ├── conftest.py                   # fixtures
│   ├── unit/
│   │   ├── test_policy.py
│   │   ├── test_enforcer.py
│   │   ├── test_agent.py
│   │   └── test_rules.py
│   ├── integration/
│   │   ├── test_graph.py
│   │   ├── test_dispute_flow.py
│   │   └── test_clawback.py
│   └── e2e/
│       └── test_full_simulation.py
│
├── notebooks/                        # Jupyter notebooks
│   ├── 01_explore_results.ipynb
│   ├── 02_visualize_metrics.ipynb
│   └── 03_compare_scenarios.ipynb
│
└── data/                             # data (mostly gitignored)
    ├── .gitkeep
    ├── results/                      # simulation results
    └── models/                       # trained models
```
