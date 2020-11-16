---
title: "Event Sourcing with Consistency"
author: ""
date: 
lastmod: 2020-11-16T07:01:38Z
draft: true
description: ""

subtitle: "CQRS, Event Sourcing, DDD and Strong Consistency"

image: "/posts/draft__event-sourcing-with-consistency/images/1.png" 
images:
 - "/posts/draft__event-sourcing-with-consistency/images/1.png"


---

CQRS, Event Sourcing, DDD and Strong Consistency

TODO stock picture here

Here at Human Interest, we needed an auditable backend for the financial events we process. We decided to build a system using patterns from [Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) and [CQRS](https://www.martinfowler.com/bliki/CQRS.html). These patterns are commonly used with Eventual Consistency, however we decided to use Strong Consistency to simplify our logic for making financial decisions. This lead to many exciting challenges and discoveries.

#### Definitions

*   Event — An Event is a blob of data representing something that has happened. eg: a `CompanyCreatedEvent` will have details on a company that was created.
*   Event Log — The event log is an ordered list of events.
*   Materialize — Events are associated with a `materialize()` function to modify the application state. Based on the data in the event, the materializer will update the application state in a transaction. eg: A `CreateCompanyEvent` materializer could add a row to the `Company` table.
*   Application State — the projection resulting from materializing events in the event log. 
*   Event Log Replay — at any given moment, the entire application state can be dropped and re-created using the event log. By re-playing the event log since the beginning, we can return to the same application state.
*   Creator — Creators are functions that produce events. eg: an `calculateInterestOwedCreator` could produce `InterestAccruedEvent` events to describe how a interest was accrued.

#### Implementation

![image](/posts/draft__event-sourcing-with-consistency/images/1.png#layoutTextWidth)


We begun with just one event log to try to keep it simple. In the future, we would like to shard the event log to reduce replay times and improve scaling. During our initial planning, we had a tough time finding good aggregate roots for our project, as there were cases where the aggregates could split apart or join together. This made it hard to find good boundaries to shard the database across. For now, we treat the entire Application State as one large Aggregate, but hopefully we can define better aggregates and shard the event log along them. 

Currently we have 2 databases, one for the Event Log and a second for the Application State. Our Application State db has an `event_log_state` table that keeps track of what events have been materialized. When we append events to the event log, we open transactions on both databases and get an `EXCLUSIVE` lock on the `event_log` table and the `event_log_state` table.

Since we have locks on both tables, any concurrent event log appending will have to wait for the current process to release these locks. Once we’ve gained both locks, we can either: append a single event, append many events, or execute a `Creator` and append the events it creates. If any of the events fail to materialize in the transaction against the Application State, we can reject the entire transaction and cleanly roll back all the events.When materialization is successful, the event log transaction is committed first, and then the Application State transaction is committed.

#### Trade-Offs

One of the big downsides for Strong Consistency is performance. During our day to day processing, we typically only have a few batch operations that run during market hours. This means we can perform maintenance (like replays) during non market hours, when downtime is acceptable.

With Strong Consistency, we have the ability to create, append, and materialize multiple events all within the same transaction. We can read data from the current (up to date) application state and use that to construct the new event to append, without worrying of an event being handled concurrently in the meantime. This helps avoid race conditions.### Challenges and Discoveries

#### IDs

Internally, we use UUIDs for IDs on entities in our databases. These IDs should be stable on replays, so we generate them when we are creating events and store them on the event itself. We also have Client IDs that are provided by external systems, which do not have to be UUIDs. Having the client provide it’s own ID means we don’t have to return an ID or any data when creating entities.

#### API

Having Strong Consistency means we can easily provide a synchronous API. An API user can hit an API to change values, and immediately see the results on subsequent API calls. If a request is bad, we can return a 4xx or 5xx status and let the client know the request failed.

#### gateways

Event Sourcing is great for keeping track of changes, but we still have to interact with external systems. We can accomplish this through a Task Gateway, which controls all asynchronous tasks that an event might want to perform. An example of this might be sending an email if a company’s address changes, or uploading a file to Amazon S3. If we decide to perform an Event Log Replay, we shouldn’t execute these tasks a second time. The Task Gateway is responsible for executing tasks once for new events, and not on subsequent replays.

#### changing logic and data

Ideally, Events in the Event log and the code for materializing events should never change. Unfortunately nothing is perfect, and we may need to fix bugs or add new functionality. If either is changed, the event log should be replayed to produce a new version of the Application State that reflects the updated logic. It’s possible that changing data or logic for an older event could produce a bad application state for a future event, and break the replayability of the event log. To avoid this, we periodically replay the entire event log to test that the replay can always work. In the future, we could automatically run replays on a separate staging server. When we do make changes, we prefer to change materialization logic, as it is checked into git. When we want to change events, we have a separate table for backups of events that were modified.

#### Event of Doom

An Event of Doom is an event that was already appended to the event log that throws an error when we try to materialize it during a replay. This may be because the event log was modified (not recommended), or because the code for the materializer was modified without considering historic data already in the log. This is a Very Bad situation that should be avoided.

#### event context

The logic for materializing an event is given the data for the event, and a `MaterializationContext`. The `MaterializationContext` provides the transaction the event is operating within, and any gateways for interacting with external systems such as logging or enqueueing tasks. The services provided on the context will be different when performing a replay, as we don’t want to perform some side effects like reporting errors.

#### Commands  vs Events

Events are always past-tense, as they are usually things that have happened externally that we have to record internally on our system. Commands (what we call Event Creators) are verbs that produce events to be processed. An example of an event could be a trade order settling, which would be named `OrderSettled` and have the details of the order that settled. An example of a Command would be `CalculateInterestOwed` which could look at current balances, and generate `InterestAccrued` events based on those balances. By handling the `CalculateInterestOwed` Command as a single atomic operation, we can read and modify balances in the same transaction, or reject the entire Command if it is invalid.### Code Examples

Interfaces:




An Event:




A Creator:




### Conclusion

So far, Event Sourcing has been working pretty well and hasn’t been too difficult to work with. Large database changes are easy to make, as it’s easy to rebuild the Application State with an Event Log Replay. Tests are easy to write, as we can test each event on it’s own. Event Sourcing isn’t a great fit for every problem, but it’s a great fit for finance!

#### Recommended reading

*   [1 Year of Event Sourcing](https://hackernoon.com/1-year-of-event-sourcing-and-cqrs-fb9033ccd1c6)
*   [Entry Level Event Sourcing](https://softwaremill.com/entry-level-event-sourcing/)
*   [Event Driven Architecture](https://www.youtube.com/watch?v=STKCRSUsyP0)
*   [Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html)
*   [Aggregate](https://martinfowler.com/bliki/DDD_Aggregate.html)
*   [CQRS](http://cqrs.nu/Faq)
