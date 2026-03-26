grep -m1 -A1 prefix cleanifier/*.log > cleanifier_log.summary
 cat cleanifier_log.summary |grep cleanifier|grep -v prefix|awk -F '/' '{print $8}'> cleanifier.log
