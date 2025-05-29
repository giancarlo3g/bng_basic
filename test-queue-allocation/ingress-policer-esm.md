

Policer configuration
```
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" description "BNG SAP-Ingress QoS Policy for HSI subscriber MSAPs - Policer"
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" policy-id 213
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" policer 62 arbiter-parent arbiter-name "root"
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" policer 62 rate pir 100000
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" fc "af" policer 62
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" fc "be" policer 62
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" fc "ef" policer 62
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" fc "h1" policer 62
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" fc "h2" policer 62
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" fc "l1" policer 62
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" fc "l2" policer 62
/configure qos sap-ingress "BNG_Subscriber_HSI_Policer" fc "nc" policer 62
```


SLA- and Sub- profiles
```
/configure subscriber-mgmt sub-profile "BNG_HSI_Sub_Profile" sla-profile-map entry "1024kbps-down" sla-profile "1024kbps-down"
/configure subscriber-mgmt sub-profile "BNG_HSI_Sub_Profile" sla-profile-map entry "UpTo1Gbps" sla-profile "UpTo1Gbps"
/configure subscriber-mgmt sla-profile "1024kbps-down" description "1 Mbps SLA-Profile for BNG HSI subscribers"
/configure subscriber-mgmt sla-profile "1024kbps-down" egress qos sap-egress policy-name "BNG_Subscriber_HSI"
/configure subscriber-mgmt sla-profile "1024kbps-down" egress qos sap-egress overrides queue 1 rate pir 1024
/configure subscriber-mgmt sla-profile "1024kbps-down" ingress qos sap-ingress policy-name "BNG_Subscriber_HSI_Policer"
/configure subscriber-mgmt sla-profile "UpTo1Gbps" description "Up-to-1Gbps SLA-Profile for BNG HSI subscribers"
/configure subscriber-mgmt sla-profile "UpTo1Gbps" egress qos sap-egress policy-name "BNG_Subscriber_HSI"
/configure subscriber-mgmt sla-profile "UpTo1Gbps" egress qos sap-egress overrides queue 1 rate pir 980000
/configure subscriber-mgmt sla-profile "UpTo1Gbps" ingress qos sap-ingress policy-name "BNG_Subscriber_HSI"
/configure subscriber-mgmt sla-profile "UpTo1Gbps" ingress qos sap-ingress overrides queue 1 rate pir 980000
/configure subscriber-mgmt sla-profile "sla-prof-internet" { }
/configure subscriber-mgmt sla-profile "sla-prof-video" { }
/configure subscriber-mgmt sla-profile "sla-prof-voice" { }
```

MSAP policy
```
/configure subscriber-mgmt msap-policy "msap-policy-1" sub-sla-mgmt subscriber-limit 1000
/configure subscriber-mgmt msap-policy "msap-policy-1" sub-sla-mgmt sub-ident-policy "sub-id-default"
/configure subscriber-mgmt msap-policy "msap-policy-1" sub-sla-mgmt defaults sla-profile "sla-prof-default"
/configure subscriber-mgmt msap-policy "msap-policy-1" sub-sla-mgmt defaults sub-profile "sub-prof-default"
/configure subscriber-mgmt msap-policy "msap-policy-1" sub-sla-mgmt single-sub-parameters profiled-traffic-only true
```

Capture SAP 
```
/configure service vpls "autovlan" admin-state enable
/configure service vpls "autovlan" service-id 2001
/configure service vpls "autovlan" customer "1"
/configure service vpls "autovlan" capture-sap lag-100:2000.* admin-state enable
/configure service vpls "autovlan" capture-sap lag-100:2000.* radius-auth-policy "radius-policy"
/configure service vpls "autovlan" capture-sap lag-100:2000.* trigger-packet dhcp true
/configure service vpls "autovlan" capture-sap lag-100:2000.* trigger-packet dhcp6 true
/configure service vpls "autovlan" capture-sap lag-100:2000.* msap-defaults policy "msap-policy-1"
/configure service vpls "autovlan" capture-sap lag-100:2000.* msap-defaults service-name "residential"
/configure service vpls "autovlan" capture-sap lag-100:2000.* ipoe-session admin-state enable
/configure service vpls "autovlan" capture-sap lag-100:2000.* ipoe-session ipoe-session-policy "IPOE-POLICY"
```

Output results for queue consumption

```
A:admin@bng1# /show service active-subscribers hierarchy

===============================================================================
Active Subscribers Hierarchy
===============================================================================
-- ONT_123456
   (sub-prof-default)
   |
   |-- sap:[lag-100:2000.2011] - sla:1024kbps-down
   |   |
   |   +-- IPOE-session - mac:02:42:ac:11:01:01 - svc:3000
   |       |
   |       +-- 172.16.10.10 - DHCP
   |
   |-- sap:[lag-100:2000.2012] - sla:1024kbps-down
   |   |
   |   +-- IPOE-session - mac:02:42:ac:11:01:02 - svc:3000
   |       |
   |       +-- 172.16.20.20 - DHCP
   |
   +-- sap:[lag-100:2000.2013] - sla:1024kbps-down
       |
       +-- IPOE-session - mac:02:42:ac:11:01:03 - svc:3000
           |
           +-- 172.16.30.30 - DHCP

-- ONT_654321
   (sub-prof-default)
   |
   +-- sap:[lag-100:2000.2021] - sla:1024kbps-down
       |
       +-- IPOE-session - mac:02:42:ac:11:02:01 - svc:3000
           |
           +-- 172.16.10.11 - DHCP

-------------------------------------------------------------------------------
Number of active subscribers : 2
Flags: (N) = the host or the managed route is in non-forwarding state
===============================================================================
```

```
A:admin@bng1# /show service id * subscriber-hosts | match 'Number of subscriber hosts'
Number of subscriber hosts : 4
Number of subscriber hosts : 4
```

```
A:admin@bng1# /show service sap-using | match "Number of SAPs"
Number of SAPs : 11
```

```
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

```
A:admin@bng1# /tools dump resource-usage card all | match 'SAP Instances \+ ' ### per card
                            SAP Instances +      196607          11      196596
                            SAP Instances +      196607           0      196607
```

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

```
A:admin@bng1# /show pools "1/1/c2/1" access-ingress | match 'Queue : '
```

```
A:admin@bng1# /show pools "1/1/c3/1" access-ingress | match 'Queue : '
Queue : 3000->lag-100:2000.4092(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4093(1/1/c3/1)->1
Queue : 3000->lag-100:2000.4094(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2011(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2013(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2021(1/1/c3/1)->1
Queue : 3000->lag-100:2000.2012(1/1/c3/1)->1     
```

```
A:admin@bng1# /show pools "1/1/c7/1" access-ingress | match 'Queue : '
Queue : 3000->1/1/c7/1:3001->1
Queue : 3000->1/1/c7/1:3002->1
Queue : 3000->1/1/c7/1:3003->1
```      

```
A:admin@bng1# /show service active-subscribers subscriber * detail  ### for queue/policer being used per sub

===============================================================================
Active Subscribers
===============================================================================
-------------------------------------------------------------------------------
Subscriber ONT_123456
           (sub-prof-default)
-------------------------------------------------------------------------------
I. Sched. Policy : N/A                              
E. Sched. Policy : N/A                              E. Agg Rate Limit: Max
Adaptation-rule  : closest                          E. Min Resv Bw   : 1
Burst-limit      : default                          
I. Policer Ctrl. : root                             
E. Policer Ctrl. : N/A                              
I. vport-hashing : Disabled                         
I. sec-sh-hashing: Disabled                         
Q Frame-Based Ac*: Disabled                         
Acct. Policy     : N/A                              Collect Stats    : Disabled
ANCP Pol.        : N/A                              
Accu-stats-pol   : (Not Specified)                  
HostTrk Pol.     : N/A                              
IGMP Policy      : N/A                              
MLD Policy       : N/A                              
PIM Policy       : N/A                              
Sub. MCAC Policy : N/A                              
NAT Policy       : N/A
Firewall Policy  : N/A                              
UPnP Policy      : N/A                              
NAT Prefix List  : N/A                              
Allow NAT bypass : No                               
NAT access mode  : auto                             
Def. Encap Offset: none                             Encap Offset Mode: none
Vol stats type   : full                             
Preference       : 5                                
LAG hash class   : 1                                
LAG hash weight  : 1                                
Sub. ANCP-String : "ONT_123456"
Sub. Int Dest Id : ""
Igmp Rate Adj    : N/A                              
RADIUS Rate-Limit: N/A                              
Oper-Rate-Limit  : Maximum                          
QoS-model        : fp                               
-------------------------------------------------------------------------------
Radius Accounting
-------------------------------------------------------------------------------
Policy           : N/A                              
Session Opti.Stop: False                            
Oversubscribed   : False                            
* indicates that the corresponding row element may have been truncated.
-------------------------------------------------------------------------------
(1) SLA Profile Instance
    - sap:[lag-100:2000.2011] (VPRN 3000 - toOLT1-Internet)
    - sla:1024kbps-down
-------------------------------------------------------------------------------
Description          : 1 Mbps SLA-Profile for BNG HSI subscribers
Control plane(s)     : local                  
Alternate-profile    : (Not Specified)
Host Limits          : No Limit
Session Limits       : No Limit
Egr Sched-Policy     : N/A                    
Ingress Qos-Policy   : 213                    Egress Qos-Policy : 21
Ingress Queuing Type : Service-queuing (Not Applicable to Policer)
Ingr IP Fltr-Id      : N/A                    Egr IP Fltr-Id    : N/A
Ingr IPv6 Fltr-Id    : N/A                    Egr IPv6 Fltr-Id  : N/A
Ingress Report-Rate  : Maximum                
Egress Report-Rate   : Maximum                
Egress Remarking     : from Sap Qos           
Credit Control Pol.  : N/A
Category Map         : (Not Specified)        
Use ing L2TP DSCP    : false                  
Default SPI sharing  : per-sap                
Bonding Rate-thresh. : high 90 low 80         
Bonding Weight       : weight 100 5           
Hs-Oper-Rate-Limit   : Maximum                
Egr hqos mgmt status : disabled               
Ing hqos mgmt status : disabled               
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
IP Address                                                                  
              MAC Address        Session            Origin       Svc        Fwd
-------------------------------------------------------------------------------
172.16.10.10
              02:42:ac:11:01:01  IPoE               DHCP         3000       Y
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
SLA Profile Instance statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Off. HiPrio           : 0                       0                        
Off. LowPrio          : 0                       0                        
Off. Uncolor          : 0                       0                        
Off. Managed          : 0                       0                        

Queueing Stats (Ingress QoS Policy 213)
Dro. HiPrio           : 0                       0                        
Dro. LowPrio          : 0                       0                        
For. InProf           : 0                       0                        
For. OutProf          : 0                       0                        

Queueing Stats (Egress QoS Policy 21)
Dro. In/InplusProf    : 0                       0                        
Dro. Out/ExcProf      : 0                       0                        
For. In/InplusProf    : 0                       0                        
For. Out/ExcProf      : 0                       0                        

-------------------------------------------------------------------------------
SLA Profile Instance per Queue statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Egress Queue 1 
Dro. In/InplusProf    : 0                       0                        
Dro. Out/ExcProf      : 0                       0                        
For. In/InplusProf    : 0                       0                        
For. Out/ExcProf      : 0                       0                        

-------------------------------------------------------------------------------
SLA Profile Instance per Policer statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Ingress Policer 62 (Stats mode: minimal)
Off. All              : 0                       0                        
Dro. All              : 0                       0                        
For. All              : 0                       0                        


-------------------------------------------------------------------------------
(2) SLA Profile Instance
    - sap:[lag-100:2000.2012] (VPRN 3000 - toOLT1-Voice)
    - sla:1024kbps-down
-------------------------------------------------------------------------------
Description          : 1 Mbps SLA-Profile for BNG HSI subscribers
Control plane(s)     : local                  
Alternate-profile    : (Not Specified)
Host Limits          : No Limit
Session Limits       : No Limit
Egr Sched-Policy     : N/A                    
Ingress Qos-Policy   : 213                    Egress Qos-Policy : 21
Ingress Queuing Type : Service-queuing (Not Applicable to Policer)
Ingr IP Fltr-Id      : N/A                    Egr IP Fltr-Id    : N/A
Ingr IPv6 Fltr-Id    : N/A                    Egr IPv6 Fltr-Id  : N/A
Ingress Report-Rate  : Maximum                
Egress Report-Rate   : Maximum                
Egress Remarking     : from Sap Qos           
Credit Control Pol.  : N/A
Category Map         : (Not Specified)        
Use ing L2TP DSCP    : false                  
Default SPI sharing  : per-sap                
Bonding Rate-thresh. : high 90 low 80         
Bonding Weight       : weight 100 5           
Hs-Oper-Rate-Limit   : Maximum                
Egr hqos mgmt status : disabled               
Ing hqos mgmt status : disabled               
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
IP Address                                                                  
              MAC Address        Session            Origin       Svc        Fwd
-------------------------------------------------------------------------------
172.16.20.20
              02:42:ac:11:01:02  IPoE               DHCP         3000       Y
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
SLA Profile Instance statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Off. HiPrio           : 0                       0                        
Off. LowPrio          : 0                       0                        
Off. Uncolor          : 0                       0                        
Off. Managed          : 0                       0                        

Queueing Stats (Ingress QoS Policy 213)
Dro. HiPrio           : 0                       0                        
Dro. LowPrio          : 0                       0                        
For. InProf           : 0                       0                        
For. OutProf          : 0                       0                        

Queueing Stats (Egress QoS Policy 21)
Dro. In/InplusProf    : 0                       0                        
Dro. Out/ExcProf      : 0                       0                        
For. In/InplusProf    : 0                       0                        
For. Out/ExcProf      : 0                       0                        

-------------------------------------------------------------------------------
SLA Profile Instance per Queue statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Egress Queue 1 
Dro. In/InplusProf    : 0                       0                        
Dro. Out/ExcProf      : 0                       0                        
For. In/InplusProf    : 0                       0                        
For. Out/ExcProf      : 0                       0                        

-------------------------------------------------------------------------------
SLA Profile Instance per Policer statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Ingress Policer 62 (Stats mode: minimal)
Off. All              : 0                       0                        
Dro. All              : 0                       0                        
For. All              : 0                       0                        


-------------------------------------------------------------------------------
(3) SLA Profile Instance
    - sap:[lag-100:2000.2013] (VPRN 3000 - toOLT1-Video)
    - sla:1024kbps-down
-------------------------------------------------------------------------------
Description          : 1 Mbps SLA-Profile for BNG HSI subscribers
Control plane(s)     : local                  
Alternate-profile    : (Not Specified)
Host Limits          : No Limit
Session Limits       : No Limit
Egr Sched-Policy     : N/A                    
Ingress Qos-Policy   : 213                    Egress Qos-Policy : 21
Ingress Queuing Type : Service-queuing (Not Applicable to Policer)
Ingr IP Fltr-Id      : N/A                    Egr IP Fltr-Id    : N/A
Ingr IPv6 Fltr-Id    : N/A                    Egr IPv6 Fltr-Id  : N/A
Ingress Report-Rate  : Maximum                
Egress Report-Rate   : Maximum                
Egress Remarking     : from Sap Qos           
Credit Control Pol.  : N/A
Category Map         : (Not Specified)        
Use ing L2TP DSCP    : false                  
Default SPI sharing  : per-sap                
Bonding Rate-thresh. : high 90 low 80         
Bonding Weight       : weight 100 5           
Hs-Oper-Rate-Limit   : Maximum                
Egr hqos mgmt status : disabled               
Ing hqos mgmt status : disabled               
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
IP Address                                                                  
              MAC Address        Session            Origin       Svc        Fwd
-------------------------------------------------------------------------------
172.16.30.30
              02:42:ac:11:01:03  IPoE               DHCP         3000       Y
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
SLA Profile Instance statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Off. HiPrio           : 0                       0                        
Off. LowPrio          : 0                       0                        
Off. Uncolor          : 0                       0                        
Off. Managed          : 0                       0                        

Queueing Stats (Ingress QoS Policy 213)
Dro. HiPrio           : 0                       0                        
Dro. LowPrio          : 0                       0                        
For. InProf           : 0                       0                        
For. OutProf          : 0                       0                        

Queueing Stats (Egress QoS Policy 21)
Dro. In/InplusProf    : 0                       0                        
Dro. Out/ExcProf      : 0                       0                        
For. In/InplusProf    : 0                       0                        
For. Out/ExcProf      : 0                       0                        

-------------------------------------------------------------------------------
SLA Profile Instance per Queue statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Egress Queue 1 
Dro. In/InplusProf    : 0                       0                        
Dro. Out/ExcProf      : 0                       0                        
For. In/InplusProf    : 0                       0                        
For. Out/ExcProf      : 0                       0                        

-------------------------------------------------------------------------------
SLA Profile Instance per Policer statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Ingress Policer 62 (Stats mode: minimal)
Off. All              : 0                       0                        
Dro. All              : 0                       0                        
For. All              : 0                       0                        


===============================================================================

===============================================================================
Active Subscribers
===============================================================================
-------------------------------------------------------------------------------
Subscriber ONT_654321
           (sub-prof-default)
-------------------------------------------------------------------------------
I. Sched. Policy : N/A                              
E. Sched. Policy : N/A                              E. Agg Rate Limit: Max
Adaptation-rule  : closest                          E. Min Resv Bw   : 1
Burst-limit      : default                          
I. Policer Ctrl. : root                             
E. Policer Ctrl. : N/A                              
I. vport-hashing : Disabled                         
I. sec-sh-hashing: Disabled                         
Q Frame-Based Ac*: Disabled                         
Acct. Policy     : N/A                              Collect Stats    : Disabled
ANCP Pol.        : N/A                              
Accu-stats-pol   : (Not Specified)                  
HostTrk Pol.     : N/A                              
IGMP Policy      : N/A                              
MLD Policy       : N/A                              
PIM Policy       : N/A                              
Sub. MCAC Policy : N/A                              
NAT Policy       : N/A
Firewall Policy  : N/A                              
UPnP Policy      : N/A                              
NAT Prefix List  : N/A                              
Allow NAT bypass : No                               
NAT access mode  : auto                             
Def. Encap Offset: none                             Encap Offset Mode: none
Vol stats type   : full                             
Preference       : 5                                
LAG hash class   : 1                                
LAG hash weight  : 1                                
Sub. ANCP-String : "ONT_654321"
Sub. Int Dest Id : ""
Igmp Rate Adj    : N/A                              
RADIUS Rate-Limit: N/A                              
Oper-Rate-Limit  : Maximum                          
QoS-model        : fp                               
-------------------------------------------------------------------------------
Radius Accounting
-------------------------------------------------------------------------------
Policy           : N/A                              
Session Opti.Stop: False                            
Oversubscribed   : False                            
* indicates that the corresponding row element may have been truncated.
-------------------------------------------------------------------------------
(1) SLA Profile Instance
    - sap:[lag-100:2000.2021] (VPRN 3000 - toOLT1-Internet)
    - sla:1024kbps-down
-------------------------------------------------------------------------------
Description          : 1 Mbps SLA-Profile for BNG HSI subscribers
Control plane(s)     : local                  
Alternate-profile    : (Not Specified)
Host Limits          : No Limit
Session Limits       : No Limit
Egr Sched-Policy     : N/A                    
Ingress Qos-Policy   : 213                    Egress Qos-Policy : 21
Ingress Queuing Type : Service-queuing (Not Applicable to Policer)
Ingr IP Fltr-Id      : N/A                    Egr IP Fltr-Id    : N/A
Ingr IPv6 Fltr-Id    : N/A                    Egr IPv6 Fltr-Id  : N/A
Ingress Report-Rate  : Maximum                
Egress Report-Rate   : Maximum                
Egress Remarking     : from Sap Qos           
Credit Control Pol.  : N/A
Category Map         : (Not Specified)        
Use ing L2TP DSCP    : false                  
Default SPI sharing  : per-sap                
Bonding Rate-thresh. : high 90 low 80         
Bonding Weight       : weight 100 5           
Hs-Oper-Rate-Limit   : Maximum                
Egr hqos mgmt status : disabled               
Ing hqos mgmt status : disabled               
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
IP Address                                                                  
              MAC Address        Session            Origin       Svc        Fwd
-------------------------------------------------------------------------------
172.16.10.11
              02:42:ac:11:02:01  IPoE               DHCP         3000       Y
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
SLA Profile Instance statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Off. HiPrio           : 0                       0                        
Off. LowPrio          : 0                       0                        
Off. Uncolor          : 0                       0                        
Off. Managed          : 0                       0                        

Queueing Stats (Ingress QoS Policy 213)
Dro. HiPrio           : 0                       0                        
Dro. LowPrio          : 0                       0                        
For. InProf           : 0                       0                        
For. OutProf          : 0                       0                        

Queueing Stats (Egress QoS Policy 21)
Dro. In/InplusProf    : 0                       0                        
Dro. Out/ExcProf      : 0                       0                        
For. In/InplusProf    : 0                       0                        
For. Out/ExcProf      : 0                       0                        

-------------------------------------------------------------------------------
SLA Profile Instance per Queue statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Egress Queue 1 
Dro. In/InplusProf    : 0                       0                        
Dro. Out/ExcProf      : 0                       0                        
For. In/InplusProf    : 0                       0                        
For. Out/ExcProf      : 0                       0                        

-------------------------------------------------------------------------------
SLA Profile Instance per Policer statistics
-------------------------------------------------------------------------------
                        Packets                 Octets

Ingress Policer 62 (Stats mode: minimal)
Off. All              : 0                       0                        
Dro. All              : 0                       0                        
For. All              : 0                       0                        


===============================================================================
```

```
A:admin@bng1# /show qos policer subscriber *

===============================================================================
Policer Information (Summary), Slot 1
===============================================================================
-------------------------------------------------------------------------------
Name                FC-Maps       MBS       HP-Only A.PIR    A.CIR
Direction                         CBS       Depth   O.PIR    O.CIR    O.FIR
-------------------------------------------------------------------------------
Sub=ONT_123456:1024kbps-down 3000->lag-100:2000.2011(1/1/c3/1)->62
Ingress             be l2 af l1   124 KB    16 KB   100000   0         
                    h2 ef h1 nc   0 KB      0       100000   0        100000
Sub=ONT_123456:1024kbps-down 3000->lag-100:2000.2013(1/1/c3/1)->62
Ingress             be l2 af l1   124 KB    16 KB   100000   0         
                    h2 ef h1 nc   0 KB      0       100000   0        100000
Sub=ONT_123456:1024kbps-down 3000->lag-100:2000.2012(1/1/c3/1)->62
Ingress             be l2 af l1   124 KB    16 KB   100000   0         
                    h2 ef h1 nc   0 KB      0       100000   0        100000
===============================================================================

===============================================================================
Policer Information (Summary), Slot 1
===============================================================================
-------------------------------------------------------------------------------
Name                FC-Maps       MBS       HP-Only A.PIR    A.CIR
Direction                         CBS       Depth   O.PIR    O.CIR    O.FIR
-------------------------------------------------------------------------------
Sub=ONT_654321:1024kbps-down 3000->lag-100:2000.2021(1/1/c3/1)->62
Ingress             be l2 af l1   124 KB    16 KB   100000   0         
                    h2 ef h1 nc   0 KB      0       100000   0        100000
===============================================================================
```