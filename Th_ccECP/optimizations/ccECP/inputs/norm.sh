#!usr/bin/env bash

#### NORM RELATED
MY_ECP=`cat pp.d`
cp ../blank.param ../opium_norm/Tb.param
sed -i "s/MY_ECP/${MY_ECP//$'\n'/\\n}/g" ../opium_norm/Tb.param
