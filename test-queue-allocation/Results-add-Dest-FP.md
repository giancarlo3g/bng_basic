# Destination FP complexes

## Objective
Evaluate ingress and egress queue consumption with different number of network or access ports.

## Lab test
Before adding more destination FP

```
A:admin@bng1# /tools dump resource-usage card all | match 'Egress Queues|Ingress Queues|Ingress Policers|Egress Policers' ### per complex
                              Ingress Queues |     131072        957     130115
                               Egress Queues |     131072         61     131011
                            Ingress Policers |     393215          5     393210
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        859     130213
                               Egress Queues |     131072         31     131041
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
```

### 1. Network port
```
+   /configure port 1/1/c20 admin-state enable
+   /configure port 1/1/c20 connector breakout c1-100g
+   /configure { port 1/1/c20/1 }
+   /configure router "Base" interface "tobng2-2" port 1/1/c20/1
+   /configure router "Base" interface "tobng2-2" ipv4 unnumbered system
+   /configure { router "Base" interface "tobng2-2" ipv6 }
+   /configure router "Base" isis 0 interface "tobng2-2" interface-type point-to-point
```

Increased ingress queues in comples 1/1 and ingress/egress queues in complex 1/2

```
(gl)[/]
A:admin@bng1# /tools dump resource-usage card all | match 'Egress Queues|Ingress Queues|Ingress Policers|Egress Policers' ### per complex
                              Ingress Queues |     131072        967     130105
                               Egress Queues |     131072         61     131011
                            Ingress Policers |     393215          5     393210
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        843     130229
                               Egress Queues |     131072         39     131033
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        859     130213
                               Egress Queues |     131072         31     131041
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
```

### 2. Acesss port in same service
```
+   /configure port 2/1/c2 admin-state enable
+   /configure port 2/1/c2 connector breakout c1-100g
+   /configure port 2/1/c2/1 admin-state enable
+   /configure port 2/1/c2/1 ethernet mode access
+   /configure port 2/1/c2/1 ethernet encap-type null
+   /configure port 2/1/c2/1 ethernet lldp dest-mac nearest-bridge receive true
+   /configure port 2/1/c2/1 ethernet lldp dest-mac nearest-bridge transmit true
+   /configure port 2/1/c2/1 ethernet lldp dest-mac nearest-bridge tx-tlvs port-desc true
+   /configure port 2/1/c2/1 ethernet lldp dest-mac nearest-bridge tx-tlvs sys-name true
+   /configure port 2/1/c2/1 ethernet lldp dest-mac nearest-bridge tx-tlvs sys-desc true
+   /configure port 2/1/c2/1 ethernet lldp dest-mac nearest-bridge tx-tlvs sys-cap true
+   /configure { service vprn "residential" interface "test" sap 2/1/c2/1 }
```

Increased ingress queues in complex 1/1 and ingress/egress queues in complex 2/1

```
A:admin@bng1# /tools dump resource-usage card all | match 'Egress Queues|Ingress Queues|Ingress Policers|Egress Policers'
                              Ingress Queues |     131072        977     130095
                               Egress Queues |     131072         61     131011
                            Ingress Policers |     393215          5     393210
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        843     130229
                               Egress Queues |     131072         39     131033
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        862     130210
                               Egress Queues |     131072         36     131036
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        755     130317
                               Egress Queues |     131072         31     131041
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
```

### 3. Access port in different service
```
+   /configure port 2/1/c20 admin-state enable
+   /configure port 2/1/c20 connector breakout c1-100g
+   /configure port 2/1/c20/1 admin-state enable
+   /configure port 2/1/c20/1 ethernet mode access
+   /configure port 2/1/c20/1 ethernet encap-type null
+   /configure port 2/1/c20/1 ethernet lldp dest-mac nearest-bridge receive true
+   /configure port 2/1/c20/1 ethernet lldp dest-mac nearest-bridge transmit true
+   /configure port 2/1/c20/1 ethernet lldp dest-mac nearest-bridge tx-tlvs port-desc true
+   /configure port 2/1/c20/1 ethernet lldp dest-mac nearest-bridge tx-tlvs sys-name true
+   /configure port 2/1/c20/1 ethernet lldp dest-mac nearest-bridge tx-tlvs sys-desc true
+   /configure port 2/1/c20/1 ethernet lldp dest-mac nearest-bridge tx-tlvs sys-cap true
+   /configure service vpls "other" admin-state enable
+   /configure service vpls "other" service-id 2040
+   /configure service vpls "other" customer "1"
+   /configure { service vpls "other" sap 2/1/c20/1 }
```
Increased ingress/egress queues in complex 2/2

```
A:admin@bng1# /tools dump resource-usage card all | match 'Egress Queues|Ingress Queues|Ingress Policers|Egress Policers'
                              Ingress Queues |     131072        977     130095
                               Egress Queues |     131072         61     131011
                            Ingress Policers |     393215          5     393210
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        843     130229
                               Egress Queues |     131072         39     131033
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        862     130210
                               Egress Queues |     131072         36     131036
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
                              Ingress Queues |     131072        757     130315
                               Egress Queues |     131072         36     131036
                            Ingress Policers |     393215          1     393214
                             Egress Policers |     393215          1     393214
```



Remove config

```
delete configure port 1/1/c20
delete configure port 1/1/c20/1
delete configure router interface "tobng2-2" 
delete configure router isis interface "tobng2-2"
delete configure port 2/1/c2
delete configure port 2/1/c2/1 
delete configure port 2/1/c20 
delete configure port 2/1/c20/1 
delete configure service vpls "other" 
delete configure service vprn "residential" interface "test" 
```