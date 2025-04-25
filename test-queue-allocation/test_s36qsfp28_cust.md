
1. No subscriber-hosts

```js
A:admin@bng1# /show service active-subscribers hierarchy

===============================================================================
Active Subscribers Hierarchy
===============================================================================
-------------------------------------------------------------------------------
No active subscribers found
===============================================================================
```

```js
A:admin@bng1# /tools dump resource-usage system all | match 'Resource Usage Infor'
Resource Usage Information for System
Resource Usage Information for Card Slot #1
Resource Usage Information for Card Slot #1 FP #1
Resource Usage Information for Card Slot #1 FP #2
Resource Usage Information for Card Slot #1 MDA #1
Resource Usage Information for Card Slot #2
Resource Usage Information for Card Slot #2 FP #1
Resource Usage Information for Card Slot #2 FP #2
Resource Usage Information for Card Slot #2 MDA #1
```

```js
A:admin@bng1# /tools dump resource-usage card all | match 'Egress Queues|Ingress Queues'
                              Ingress Queues |     131072        952     130120
                               Egress Queues |     131072         53     131019
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
                              Ingress Queues |     131072        858     130214
                               Egress Queues |     131072         31     131041
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
```

```js
A:admin@bng1# /show pools "1/1/c2/1" access-ingress | match 'Queue : '
```

```js
A:admin@bng1# /show pools "1/1/c3/1" access-ingress | match 'Queue : '
Queue : 3000->lag-100:2000.4092(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4093(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4094(1/1/c3/1)->1
```

```js
A:admin@bng1# /show pools "1/1/c7/1" access-ingress | match 'Queue : '
Queue : 3000->1/1/c7/1:3001->1
Queue : 3000->1/1/c7/1:3002->1
Queue : 3000->1/1/c7/1:3003->1
```

```js
A:admin@bng1# /show pools slot-number 1 fp 1 network-ingress | match 'Queue : ' | count
Count: 72 lines
```

```js
A:admin@bng1# /show pools slot-number 1 fp 2 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

```js
A:admin@bng1# /show pools slot-number 2 fp 1 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

```js
A:admin@bng1# /show pools slot-number 2 fp 2 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

2. Internet host active

```js
A:admin@bng1# /show service active-subscribers hierarchy

===============================================================================
Active Subscribers Hierarchy
===============================================================================
-- ONT_123456
   (BNG_HSI_Sub_Profile)
   |
   +-- sap:[lag-100:2000.2011] - sla:UpTo1Gbps
       |
       +-- IPOE-session - mac:02:42:ac:11:01:01 - svc:3000
           |
           +-- 172.16.10.10 - DHCP

-------------------------------------------------------------------------------
Number of active subscribers : 1
Flags: (N) = the host or the managed route is in non-forwarding state
===============================================================================
```

```js
A:admin@bng1# /tools dump resource-usage system all | match 'Resource Usage Infor'
Resource Usage Information for System
Resource Usage Information for Card Slot #1
Resource Usage Information for Card Slot #1 FP #1
Resource Usage Information for Card Slot #1 FP #2
Resource Usage Information for Card Slot #1 MDA #1
Resource Usage Information for Card Slot #2
Resource Usage Information for Card Slot #2 FP #1
Resource Usage Information for Card Slot #2 FP #2
Resource Usage Information for Card Slot #2 MDA #1
```

```js
A:admin@bng1# /tools dump resource-usage card all | match 'Egress Queues|Ingress Queues'
                              Ingress Queues |     131072        955     130117
                               Egress Queues |     131072         55     131017
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
                              Ingress Queues |     131072        859     130213
                               Egress Queues |     131072         31     131041
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
```

```js
A:admin@bng1# /show pools "1/1/c2/1" access-ingress | match 'Queue : '
```

```js
A:admin@bng1# /show pools "1/1/c3/1" access-ingress | match 'Queue : '
Queue : 3000->lag-100:2000.4092(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4093(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4094(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2011(1/1/c3/1)->1
Queue : Sub=ONT_123456:UpTo1Gbps 3000->lag-100:2000.2011(1/1/c3/1)->1
```

```js
A:admin@bng1# /show pools "1/1/c7/1" access-ingress | match 'Queue : '
Queue : 3000->1/1/c7/1:3003->1
Queue : 3000->1/1/c7/1:3001->1
Queue : 3000->1/1/c7/1:3002->1
```

```js
A:admin@bng1# /show pools slot-number 1 fp 1 network-ingress | match 'Queue : ' | count
Count: 72 lines
```

```js
A:admin@bng1# /show pools slot-number 1 fp 2 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

```js
A:admin@bng1# /show pools slot-number 2 fp 1 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

```js
A:admin@bng1# /show pools slot-number 2 fp 2 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

3. Second host (voice) active

```js
A:admin@bng1# /show service active-subscribers hierarchy

===============================================================================
Active Subscribers Hierarchy
===============================================================================
-- ONT_123456
   (sub-prof-500M)
   |
   |-- sap:[lag-100:2000.2011] - sla:UpTo1Gbps
   |   |
   |   +-- IPOE-session - mac:02:42:ac:11:01:01 - svc:3000
   |       |
   |       +-- 172.16.10.10 - DHCP
   |
   +-- sap:[lag-100:2000.2012] - sla:sla-prof-voice
       |
       +-- IPOE-session - mac:02:42:ac:11:01:02 - svc:3000
           |
           +-- 172.16.20.20 - DHCP

-------------------------------------------------------------------------------
Number of active subscribers : 1
Flags: (N) = the host or the managed route is in non-forwarding state
===============================================================================
```

```js
A:admin@bng1# /tools dump resource-usage system all | match 'Resource Usage Infor'
Resource Usage Information for System
Resource Usage Information for Card Slot #1
Resource Usage Information for Card Slot #1 FP #1
Resource Usage Information for Card Slot #1 FP #2
Resource Usage Information for Card Slot #1 MDA #1
Resource Usage Information for Card Slot #2
Resource Usage Information for Card Slot #2 FP #1
Resource Usage Information for Card Slot #2 FP #2
Resource Usage Information for Card Slot #2 MDA #1
```

```js
A:admin@bng1# /tools dump resource-usage card all | match 'Egress Queues|Ingress Queues'
                              Ingress Queues |     131072        957     130115
                               Egress Queues |     131072         57     131015
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
                              Ingress Queues |     131072        859     130213
                               Egress Queues |     131072         31     131041
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
```

```js
A:admin@bng1# /show pools "1/1/c2/1" access-ingress | match 'Queue : '
```

```js
A:admin@bng1# /show pools "1/1/c3/1" access-ingress | match 'Queue : '
Queue : 3000->lag-100:2000.4092(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4093(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4094(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2011(1/1/c3/1)->1
Queue : Sub=ONT_123456:UpTo1Gbps 3000->lag-100:2000.2011(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2012(1/1/c3/1)->1
Queue : Sub=ONT_123456:sla-prof-voice 3000->lag-100:2000.2012(1/1/c3/1)->1
```

```js
A:admin@bng1# /show pools "1/1/c7/1" access-ingress | match 'Queue : '
Queue : 3000->1/1/c7/1:3003->1
Queue : 3000->1/1/c7/1:3001->1
Queue : 3000->1/1/c7/1:3002->1
```

```js
A:admin@bng1# /show pools slot-number 1 fp 1 network-ingress | match 'Queue : ' | count
Count: 72 lines
```

```js
A:admin@bng1# /show pools slot-number 1 fp 2 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

```js
A:admin@bng1# /show pools slot-number 2 fp 1 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

```js
A:admin@bng1# /show pools slot-number 2 fp 2 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

4. Three hosts active

```js
A:admin@bng1# /show service active-subscribers hierarchy

===============================================================================
Active Subscribers Hierarchy
===============================================================================
-- ONT_123456
   (sub-prof-500M)
   |
   |-- sap:[lag-100:2000.2011] - sla:UpTo1Gbps
   |   |
   |   +-- IPOE-session - mac:02:42:ac:11:01:01 - svc:3000
   |       |
   |       +-- 172.16.10.10 - DHCP
   |
   |-- sap:[lag-100:2000.2012] - sla:sla-prof-voice
   |   |
   |   +-- IPOE-session - mac:02:42:ac:11:01:02 - svc:3000
   |       |
   |       +-- 172.16.20.20 - DHCP
   |
   +-- sap:[lag-100:2000.2013] - sla:sla-prof-video
       |
       +-- IPOE-session - mac:02:42:ac:11:01:03 - svc:3000
           |
           +-- 172.16.30.30 - DHCP

-------------------------------------------------------------------------------
Number of active subscribers : 1
Flags: (N) = the host or the managed route is in non-forwarding state
===============================================================================
```

```js
A:admin@bng1# /tools dump resource-usage system all | match 'Resource Usage Infor'
Resource Usage Information for System
Resource Usage Information for Card Slot #1
Resource Usage Information for Card Slot #1 FP #1
Resource Usage Information for Card Slot #1 FP #2
Resource Usage Information for Card Slot #1 MDA #1
Resource Usage Information for Card Slot #2
Resource Usage Information for Card Slot #2 FP #1
Resource Usage Information for Card Slot #2 FP #2
Resource Usage Information for Card Slot #2 MDA #1
```

```js
A:admin@bng1# /tools dump resource-usage card all | match 'Egress Queues|Ingress Queues'
                              Ingress Queues |     131072        959     130113
                               Egress Queues |     131072         59     131013
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
                              Ingress Queues |     131072        859     130213
                               Egress Queues |     131072         31     131041
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
```

```js
A:admin@bng1# /show pools "1/1/c2/1" access-ingress | match 'Queue : '
```

```js
A:admin@bng1# /show pools "1/1/c3/1" access-ingress | match 'Queue : '
Queue : 3000->lag-100:2000.4092(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4093(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4094(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2011(1/1/c3/1)->1
Queue : Sub=ONT_123456:UpTo1Gbps 3000->lag-100:2000.2011(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2012(1/1/c3/1)->1
Queue : Sub=ONT_123456:sla-prof-voice 3000->lag-100:2000.2012(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2013(1/1/c3/1)->1
Queue : Sub=ONT_123456:sla-prof-video 3000->lag-100:2000.2013(1/1/c3/1)->1
```

```js
A:admin@bng1# /show pools "1/1/c7/1" access-ingress | match 'Queue : '
Queue : 3000->1/1/c7/1:3003->1
Queue : 3000->1/1/c7/1:3001->1
Queue : 3000->1/1/c7/1:3002->1
```

```js
A:admin@bng1# /show pools slot-number 1 fp 1 network-ingress | match 'Queue : ' | count
Count: 72 lines
```

```js
A:admin@bng1# /show pools slot-number 1 fp 2 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

```js
A:admin@bng1# /show pools slot-number 2 fp 1 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

```js
A:admin@bng1# /show pools slot-number 2 fp 2 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

5. 2 subscribers, 4 hosts

```js
A:admin@bng1# /show service active-subscribers hierarchy

===============================================================================
Active Subscribers Hierarchy
===============================================================================
-- ONT_123456
   (sub-prof-500M)
   |
   |-- sap:[lag-100:2000.2012] - sla:sla-prof-voice
   |   |
   |   +-- IPOE-session - mac:02:42:ac:11:01:02 - svc:3000
   |       |
   |       +-- 172.16.20.20 - DHCP
   |
   +-- sap:[lag-100:2000.2013] - sla:sla-prof-video
       |
       +-- IPOE-session - mac:02:42:ac:11:01:03 - svc:3000
           |
           +-- 172.16.30.30 - DHCP

-- ONT_654321
   (BNG_HSI_Sub_Profile)
   |
   +-- sap:[lag-100:2000.2011] - sla:UpTo1Gbps
       |
       +-- IPOE-session - mac:02:42:ac:11:02:01 - svc:3000
           |
           +-- 172.16.10.10 - DHCP

-------------------------------------------------------------------------------
Number of active subscribers : 2
Flags: (N) = the host or the managed route is in non-forwarding state
===============================================================================
```

```js
A:admin@bng1# /tools dump resource-usage system all | match 'Resource Usage Infor'
Resource Usage Information for System
Resource Usage Information for Card Slot #1
Resource Usage Information for Card Slot #1 FP #1
Resource Usage Information for Card Slot #1 FP #2
Resource Usage Information for Card Slot #1 MDA #1
Resource Usage Information for Card Slot #2
Resource Usage Information for Card Slot #2 FP #1
Resource Usage Information for Card Slot #2 FP #2
Resource Usage Information for Card Slot #2 MDA #1
```

```js
A:admin@bng1# /tools dump resource-usage card all | match 'Egress Queues|Ingress Queues'
                              Ingress Queues |     131072        959     130113
                               Egress Queues |     131072         59     131013
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
                              Ingress Queues |     131072        859     130213
                               Egress Queues |     131072         31     131041
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
```

```js
A:admin@bng1# /show pools "1/1/c2/1" access-ingress | match 'Queue : '
```

```js
A:admin@bng1# /show pools "1/1/c3/1" access-ingress | match 'Queue : '
Queue : 3000->lag-100:2000.4092(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4093(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4094(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2011(1/1/c3/1)->1
Queue : Sub=ONT_654321:UpTo1Gbps 3000->lag-100:2000.2011(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2012(1/1/c3/1)->1
Queue : Sub=ONT_123456:sla-prof-voice 3000->lag-100:2000.2012(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2013(1/1/c3/1)->1
Queue : Sub=ONT_123456:sla-prof-video 3000->lag-100:2000.2013(1/1/c3/1)->1
```

```js
A:admin@bng1# /show pools "1/1/c7/1" access-ingress | match 'Queue : '
Queue : 3000->1/1/c7/1:3001->1
Queue : 3000->1/1/c7/1:3002->1
Queue : 3000->1/1/c7/1:3003->1
```

```js
A:admin@bng1# /show pools slot-number 1 fp 1 network-ingress | match 'Queue : ' | count
Count: 72 lines
```

```js
A:admin@bng1# /show pools slot-number 1 fp 2 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

```js
A:admin@bng1# /show pools slot-number 2 fp 1 network-ingress | match 'Queue : ' | count
Count: 0 lines
```

```js
A:admin@bng1# /show pools slot-number 2 fp 2 network-ingress | match 'Queue : ' | count
Count: 0 lines
```