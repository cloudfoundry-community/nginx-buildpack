# ------------------------------------------------------------------------------------------------
# Copyright 2013 Jordon Bedwell.
# Apache License.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
# except  in compliance with the License. You may obtain a copy of the License at:
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the
# License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied. See the License for the specific language governing permissions
# and  limitations under the License.
# ------------------------------------------------------------------------------------------------

mv /app/nginx/conf/nginx.conf /app/nginx/conf/orig.conf
erb /app/nginx/conf/orig.conf > /app/nginx/conf/nginx.conf

# ------------------------------------------------------------------------------------------------

(tail -f -n 0 /app/nginx/logs/*.log &)
exec /app/nginx/sbin/nginx -p /app/nginx -c /app/nginx/conf/nginx.conf

# ------------------------------------------------------------------------------------------------
