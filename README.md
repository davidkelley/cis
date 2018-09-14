# CIS Hardened Container

Running `docker build -t cis .` from the root of this repository builds a CIS Hardened container, with scripts provided by OVH here: https://github.com/ovh/debian-cis.

## Further hardening

Additional hardening can be applied to the container by first determining which checks are failing, using the following command `docker run cis /opt/cis/bin/hardening.sh --audit-all`. In the subsequent output, failed checks can be easily identified; the check can be enabled by remedying the fault and enabling the check in the `conf.d/$SCRIPT_NAME.cfg` file.

### An example
Take the following broken check:

```
9.1.4_cron_daily_perm_own [INFO] Working on 9.1.4_cron_daily_perm_ownership
9.1.4_cron_daily_perm_own [INFO] Checking Configuration
9.1.4_cron_daily_perm_own [INFO] Performing audit
9.1.4_cron_daily_perm_own [ OK ] /etc/cron.daily has correct ownership
9.1.4_cron_daily_perm_own [ KO ] /etc/cron.daily permissions were not set to 700
9.1.4_cron_daily_perm_own [ KO ] Check Failed
```

We can remedy this, by adding a `RUN` directive in the `Dockerfile` to correctly set file permissions: `RUN chmod 0700 /etc/cron.daily`. After re-building the container and running the `--audit-all` command again above, we can see this check is now passing:

```
9.1.4_cron_daily_perm_own [INFO] Working on 9.1.4_cron_daily_perm_ownership
9.1.4_cron_daily_perm_own [INFO] Checking Configuration
9.1.4_cron_daily_perm_own [INFO] Performing audit
9.1.4_cron_daily_perm_own [ OK ] /etc/cron.daily has correct ownership
9.1.4_cron_daily_perm_own [ OK ] /etc/cron.daily has correct permissions
9.1.4_cron_daily_perm_own [ OK ] Check Passed
```

Adding the file `/conf.d/9.1.4_cron_daily_perm_own.cfg` with the content `status=enabled` to to the repository, will now enable this check for all future builds.
