# F5 rSeries & BIG-IP Tenant Upgrade Runbook

## Pre-Upgrade Health Checks & Backups (All Tenants)

```bash

tmsh save /sys ucs /var/local/ucs/<hostname>_pre-upgrade_$(date +%Y%m%d).ucs

```

###  Verify b tenants are on standby  (if not force it standby )

```bash

tmsh run /sys failover standby
tmsh show /cm traffic-group
tmsh show /cm sync-status


```
### 1.2 — Save Running Configuration

```bash

tmsh save /sys config

```
### Verify Configuration Integrity

```bash

tmsh load /sys config verify

```

###  Collect Pre-Upgrade Stats & Baseline

```bash

tmsh show /ltm virtual | grep -E "Name|Availability|State" >> virtual.txt
tmsh show /ltm pool members | grep -E "Name|Addr|Monitor|State" >> pool.txt

```

##  Set All "B" Side Tenants to "Configured" (Shut Down) via F5OS 

Navigate to: Tenant Management → Tenant Deployments
Change the state of each "B" tenant from Deployed → Configured.


## Upgrade "B" Side F5OS rSeries Platform

Navigate to: System Settings → Software Management
Select the target version and click Install.

## Verify F5OS Upgrade 

```bash

show system image
show running-config system image

```
## Redeploy "B" Side Tenants on Upgraded rSeries

Navigate to: Tenant Management → Tenant Deployments
Change the state of each "B" tenant from Configured → Deployed.

## Verify Tenants Are Online

## Ensure All "B" Tenants Are Still Standby

## Upgrade "B" Side BIG-IP Tenants

```bash

cpcfg --source=HD1.1 HD1.2

switchboot -b HD1.2

reboot

```

## Post-Reboot Verification

## Post-Upgrade Validation 

```bash

tmsh show /ltm virtual | grep -E "Name|Availability|State" >> post_upgrade
tmsh show /ltm pool members | grep -E "Name|Addr|Monitor|State" >> post_upgrade


```

## Failover to "B" Side to Active

On the "A" side Active tenants

```bash

tmsh run /sys failover standby
tmsh show /sys failover

```

## Upgrade "A" Side (Repeat Process)

"" Force "A" side tenants to Standby (should already be after failover)
"" Set "A" tenants to Configured on F5OS
"" Upgrade "A" side F5OS rSeries platform
"" Redeploy "A" tenants
"" Upgrade "A" side BIG-IP tenant software
"" Validate post-upgrade

## Fail Back to Original Active Side

```bash

tmsh run /sys failover standby

```

## Rollback (Optional) 

```bash

switchboot -b HD1.1
reboot

tmsh load /sys ucs /var/local/ucs/<hostname>_pre-upgrade_<date>.ucs

```
