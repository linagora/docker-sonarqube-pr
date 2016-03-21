#!/bin/bash
#

# Start Sonar
./bin/run.sh &

function curlAdmin {
    curl -v -u admin:admin $@
}

BASE_URL=http://127.0.0.1:9000

function isUp {
    curl -s -u admin:admin -f "$BASE_URL/api/system/info"
}

# Wait for server to be up
PING=`isUp`
while [ -z "$PING" ]
do
    sleep 5
    PING=`isUp`
done

# Restore qualityprofile
if [ "$LANGUAGE" ] && [ "$PROFILE_NAME" ]; then
    curlAdmin -F "backup=@/qualityprofile/qualityprofile.xml" -X POST "$BASE_URL/api/qualityprofiles/restore"
    curlAdmin -X POST "$BASE_URL/api/qualityprofiles/set_default?language=$LANGUAGE&profileName=$PROFILE_NAME"
fi

# Provision a project
if [ "$PROJECT_NAME" ] && [ "$PROJECT_KEY" ]; then
    curlAdmin -X POST "$BASE_URL/api/projects/create?name=$PROJECT_NAME&key=$PROJECT_KEY"
fi

# Provision an admini user
if [ "$USER_LOGIN" ] && [ "$USER_NAME" ] && [ "$USER_PASSWORD" ]; then
    curlAdmin -X POST "$BASE_URL/api/users/create?login=$USER_LOGIN&name=$USER_NAME&password=$USER_PASSWORD"
    curlAdmin -X POST "$BASE_URL/api/permissions/add_user?login=$USER_LOGIN&permission=admin"
    curl -v -u $USER_LOGIN:$USER_PASSWORD -X POST "$BASE_URL/api/users/deactivate?login=admin"
fi

wait
