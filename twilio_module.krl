ruleset kaiw8t_twilio_v2 {
    meta {
        use module twilio_v2_api alias twilio
            with account_sid = meta:rulesetConfig{"apiToken"}
             auth_token =  meta:rulesetConfig{"apiToken"}


        shares __testing
    }

    global {
        __testing = { 
            "queries": [{ "name": "__testing" } ],
            "events": [ 
                { "domain": "test", "type": "send_message", "attrs": ["to", "from", "message"] },
                { "domain": "test", "type": "get_messages", "attrs": ["to", "from", "pageSize"] }
             ]
            }
    }

    rule test_send {
        select when test send_message
        twilio:send_sms(event:attr("to"),
                        event:attr("from"),
                        event:attr("message")
                        )
    }

    rule test_get {
        select when test get_messages
        pre{
            messages = twilio:messages(
                        event:attr("to"),
                        event:attr("from"),
                        event:attr("pageSize")
            )
        }
        send_directive("messages", {"messages": messages})
    }
}
