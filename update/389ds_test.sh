exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

#exec_cmd rpm -ivh https://download.suse.de/ibs/SUSE:/Maintenance:/30264/SUSE_Updates_SLE-Module-Server-Applications_15-SP5_x86_64/src/389-ds-2.2.8~git37.fdb3bae-150500.3.11.1.src.rpm
exec_cmd rpm -ivh https://download.suse.de/ibs/SUSE:/Maintenance:/30254/SUSE_Updates_SLE-Module-Server-Applications_15-SP4_x86_64/src/389-ds-2.0.17~git81.849cc42-150400.3.31.1.src.rpm
exec_cmd cd /usr/src/packages/SOURCES/

rm -rf /tmp/389-ds-base*
exec_cmd tar -xvf 389-ds-base-*.tar.* -C /tmp/
cd /tmp/389-ds-base-*/dirsrvtests/tests/tickets
pytest
exit

cd ../../

if [ -e suite_tests_results.txt ]; then rm suite_tests_results.txt; fi

for tst in acl clu ds_tools gssapi logging paged_results replication \
    snmp attr_encryption config dynamic_plugins gssapi_repl \
    mapping_tree password resource_limits stat automember_plugin \
    cos filter import memberof_plugin plugins sasl syntax basic \
    disk_monitoring fourwaymmr memory_leaks psearch schema tls \
    betxns ds_logs get_effective_rights ldapi monitor setup_ds vlv; do

    ./create_test.py --suite $tst
    python3 ${tst}_test.py 2> /dev/null | tee -a suite_tests_results.txt
done

if [ -e suite_tests_tickets_results.txt ]; then rm suite_tests_tickets_results.txt; fi
for tst in `find ./tests/tickets | grep -i test | cut -d "t" -f 7 | cut -d "_" -f 1`; do
    ./create_test.py --ticket $tst
    python3 ticket${tst}_test.py 2> /dev/null | tee -a suite_tests_tickets_results.txt
done

