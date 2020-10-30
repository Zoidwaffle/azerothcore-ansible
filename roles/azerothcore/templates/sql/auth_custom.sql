-- Changes to this file will be overwritten, make changes in ./group_vars/all
update realmlist set name="{{ azerothcore_realmlist_name }}", localAddress="{{ azerothcore_realmlist_local_ip }}", address="{{ azerothcore_realmlist_ip }}" where id=1;
