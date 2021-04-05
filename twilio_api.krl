ruleset twilio_v2_api {
    meta {
        configure using account_sid = ""
                        auth_token = ""
        provides 
            send_sms,
            messages
    }

    global {
        send_sms = defaction(to, from, message) {
            base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/>>
            http:post(base_url + "Messages.json", form = {
                "From":from,
                "To":to,
                "Body":message
            })
        }

        messages = function(to, from, pageSize) {
            base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/>>;
            queryString = {};

            queryString1 = (pageSize.isnull() || pageSize == "") => queryString | queryString.put({"PageSize":pageSize});
            querystringTo = (to.isnull() || to == "") => queryString1 | queryString1.put({"To":to});
            querystringFrom = (from.isnull() || from == "") => querystringTo | querystringTo.put({"From":from});
            //queryString.klog("Testing: ");
            
            response = http:get("http://example.com/widgets/printenv.pl")
            qs = {"a": "5",
                  "version": "dev"
                 }
            response{"content"}.decode(){"messages"}
        }
    }
}
