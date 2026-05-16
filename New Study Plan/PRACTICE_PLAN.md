# Practice Plan

## Scenario
You are the first analytics engineer / data warehouse developer for a commerce company.
Operations leaders complain that:
- shipment status is inconsistent across systems
- inventory numbers do not always reconcile
- late deliveries are rising
- refund leakage is not visible early enough

You need to build a reliable analytics layer.

## Deliverable 1: staging layer
Create clean staging models for all raw files.

## Deliverable 2: core model
Build:
- dim_customer
- dim_product
- dim_warehouse
- fct_order_item
- fct_inventory_movement
- fct_shipment
- fct_return

## Deliverable 3: business marts
Build:
- mart_daily_fulfillment_kpis
- mart_inventory_health
- mart_returns_quality

## Required tests
- unique / not null on business keys
- relationships between fact tables and dimensions
- accepted values for statuses and movement types
- refund amount <= original line amount
- delivered timestamp cannot be earlier than order timestamp
- shipment events must be deduplicated to latest valid sequence

## Nice-to-have stretch goals
- SCD Type 2 for product price bands or customer segment
- anomaly detection rule for warehouse adjustment spikes
- SLA breach classification
- backfill script for late-arriving shipment events
