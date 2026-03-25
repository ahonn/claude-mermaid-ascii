# Supported Diagram Types

The pgavlin/mermaid-ascii fork supports 22 Mermaid diagram types.
The original AlexanderGrooff/mermaid-ascii supports only flowchart and sequence.

## Flowchart

```mermaid
graph LR
    A[Start] --> B{Decision}
    B -->|Yes| C[OK]
    B -->|No| D[Cancel]
```

## Sequence Diagram

```mermaid
sequenceDiagram
    Alice->>Bob: Hello
    Bob-->>Alice: Hi back
```

## Class Diagram

```mermaid
classDiagram
    Animal <|-- Duck
    Animal <|-- Fish
    Animal : +int age
    Animal : +String gender
    Duck : +swim()
    Fish : +swim()
```

## State Diagram

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing : submit
    Processing --> Done : complete
    Done --> [*]
```

## Entity Relationship Diagram

```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
```

## Gantt Chart

```mermaid
gantt
    title Project Plan
    section Design
    Wireframes :a1, 2024-01-01, 7d
    Mockups    :a2, after a1, 5d
    section Dev
    Frontend   :b1, after a2, 14d
    Backend    :b2, after a2, 14d
```

## Pie Chart

```mermaid
pie title Pets
    "Dogs" : 40
    "Cats" : 30
    "Birds" : 20
    "Fish" : 10
```

## Mindmap

```mermaid
mindmap
    root((Project))
        Frontend
            React
            CSS
        Backend
            API
            Database
```

## Timeline

```mermaid
timeline
    title History
    2020 : Project started
    2021 : v1.0 released
    2022 : v2.0 released
```

## Git Graph

```mermaid
gitGraph
    commit
    branch develop
    commit
    checkout main
    merge develop
    commit
```

## User Journey

```mermaid
journey
    title User Shopping
    section Browse
      Visit site: 5: User
      Search item: 3: User
    section Purchase
      Add to cart: 4: User
      Checkout: 3: User
```

## Quadrant Chart

```mermaid
quadrantChart
    title Reach and engagement
    x-axis Low Reach --> High Reach
    y-axis Low Engagement --> High Engagement
    quadrant-1 We should expand
    quadrant-2 Need to promote
    quadrant-3 Re-evaluate
    quadrant-4 May be improved
    Campaign A: [0.3, 0.6]
    Campaign B: [0.45, 0.23]
```

## XY Chart

```mermaid
xychart-beta
    title "Sales"
    x-axis [jan, feb, mar, apr]
    y-axis "Revenue" 0 --> 100
    bar [10, 20, 30, 40]
    line [10, 20, 30, 40]
```

## C4 Diagram

```mermaid
C4Context
    title System Context
    Person(user, "User")
    System(system, "System")
    Rel(user, system, "Uses")
```

## Requirement Diagram

```mermaid
requirementDiagram
    requirement test_req {
        id: 1
        text: the system shall do X
        risk: high
        verifymethod: test
    }
```

## Block Diagram

```mermaid
block-beta
    columns 3
    a["A"] b["B"] c["C"]
    d["D"]:3
```

## Sankey Diagram

```mermaid
sankey-beta
    Source1,Target1,25
    Source1,Target2,15
    Source2,Target2,10
```

## Packet Diagram

```mermaid
packet-beta
    0-15: "Source Port"
    16-31: "Destination Port"
    32-63: "Sequence Number"
```

## Kanban

```mermaid
kanban
    Todo
        Task 1
        Task 2
    In Progress
        Task 3
    Done
        Task 4
```

## Architecture Diagram

```mermaid
architecture-beta
    service api(server)[API]
    service db(database)[DB]
    api:R --> L:db
```

## ZenUML

```mermaid
zenuml
    Alice->Bob: request
    Bob->Alice: response
```
