# Simulated Commerce Fulfillment Dataset

## What this package is for
This package is designed for **data warehouse / analytics engineering / data operations** practice, not for generic EDA.
The scenario models a mid-sized commerce business that sells laptops, monitors, accessories, and components through:
- Website
- Amazon Marketplace
- Wholesale Portal

The business operates three fulfillment centers:
- Seattle
- Tacoma
- Portland

## Raw tables included
- `raw_customers.csv`
- `raw_products.csv`
- `raw_warehouses.csv`
- `raw_orders.csv`
- `raw_order_items.csv`
- `raw_inventory_movements.csv`
- `raw_shipment_events.csv`
- `raw_returns.csv`
- `data_dictionary.csv`

## Scale
- customers: 900
- products: 220
- warehouses: 3
- raw order rows (with duplicate CDC-like rows): 12518
- distinct orders: 12500
- order items: 20284
- inventory movements: 43601
- shipment events: 57180
- returns: 1076

## Business process represented
`order -> order item -> reserve inventory -> ship package -> track shipment -> deliver -> return/refund`

## Intentional dirty-data situations
This dataset includes realistic issues on purpose so you can practice staging, cleansing, testing, and reconciliation:
1. Some `raw_orders` rows are duplicated with a later `record_updated_ts` to simulate CDC/update handling.
2. Some `promised_delivery_ts` values are null.
3. Some shipment events arrive late (`ingestion_ts` much later than `event_ts`).
4. Some shipment events are duplicated.
5. Some shipment event sequences are out of order.
6. A few cancelled orders still have a `label_created` event.
7. Some tracking numbers are null.
8. Some refund amounts in `raw_returns` intentionally exceed the original line amount to test controls.
9. Inventory contains cycle-count adjustments and damage write-offs.

## Suggested dimensional model
### Dimensions
- `dim_date`
- `dim_customer`
- `dim_product`
- `dim_warehouse`
- `dim_carrier`
- `dim_return_reason`

### Facts
- `fct_order_item`
- `fct_inventory_movement`
- `fct_shipment_event` or `fct_shipment`
- `fct_return`

### Useful derived marts
- `mart_daily_fulfillment_kpis`
- `mart_inventory_health`
- `mart_late_delivery_root_cause`
- `mart_returns_quality`

## Recommended exercises
### Bronze / staging
- Deduplicate `raw_orders` using the latest `record_updated_ts`.
- Standardize timestamps and convert empty strings to nulls.
- Enforce primary key tests and relationship tests.
- Build accepted-values tests on status and movement types.

### Silver / core
- Build clean order, item, shipment, inventory, and return entities.
- Create one shipment-level table from raw event rows.
- Derive `actual_ship_ts`, `actual_delivery_ts`, and `delivery_exception_flag`.
- Reconcile order totals against summed line totals.

### Gold / marts
1. **Daily fulfillment KPI mart**
   - orders created
   - orders shipped
   - on-time ship %
   - on-time delivery %
   - average days to deliver
2. **Inventory health mart**
   - on-hand delta by SKU and warehouse
   - negative stock flags
   - damage write-off rate
   - return-to-restock rate
3. **Returns quality mart**
   - return rate
   - refund amount as % of sales
   - top return reasons
4. **Late delivery root-cause mart**
   - warehouse
   - carrier
   - service level
   - backorder contribution
   - exception contribution

## Good interview questions you can answer from this dataset
- Why are on-time deliveries falling?
- Which warehouse has the highest adjustment noise?
- Which SKUs are driving returns and refunds?
- How much late delivery is due to carrier issues versus internal fulfillment delay?
- Where do data quality controls catch bad records?

## Recommended technical stack for practice
### Snowflake + dbt
- load raw files into raw schema
- build staging models
- build dimensions/facts
- add tests and docs
- add incremental logic to shipment / inventory models

### Microsoft Fabric
- use Pipeline for ingestion
- use Warehouse or Lakehouse for curated layers
- use Notebook/PySpark for selected transformations if desired
- add deployment / monitoring notes

## Minimum acceptance standard for a “production-like” portfolio project
Your project is not done until it has:
- a clear grain statement for each fact table
- at least 10 data-quality tests
- a README with architecture and run steps
- at least 3 business KPIs with definitions
- one reconciliation check
- one late-arriving-data strategy
- one failure scenario and how you would handle it
