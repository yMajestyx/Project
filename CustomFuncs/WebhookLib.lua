local Request = (syn and syn.request or request or http and http.request or http_request) or error("No request function found")
local HttpService = game:GetService("HttpService")
local Network = loadstring(game:HttpGet(("https://raw.githubusercontent.com/yMajestyx/Project/main/CustomFuncs/Network.lua")))();

local WebhookSettings = {
    ["@everyone"] = false;
}

local Webhook = {}; do
    function Webhook:Send(Webhook, Message)
        local Success, Error = pcall(function()

            if WebhookSettings["@everyone"] then
                Message = string.format("@everyone %s", Message)
            end

            Request({
                Url = Webhook,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode({
                    allowed_mentions = {
                        parse = WebhookSettings["@everyone"] and {"everyone"} or {}
                    },
                    content = Message
                })
            })
        end)

        if not Success then
            error(Error)
        end
    end;

    function Webhook:ChangeName(Webhook, Name)
        local Success, Error = pcall(function()
            Request({
                Url = Webhook,
                Method = "PATCH",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode({
                    name = Name
                })
            })
        end)

        if not Success then
            error(Error)
        else
            Network:Notify("Success", string.format("Changed webhook name to %s", Name), 5)
        end
    end;

    function Webhook:GetWebhookInfo(Webhook)
        local Response, Error = Request({
            Url = Webhook,
            Method = "GET",
            Headers = {
                ["Content-Type"] = "application/json"
            }
        })

        if not Response then
            error(Error)
        else
            Network:Notify("Success", "Copied webhook info to clipboard", 5)
        end

        return setclipboard(HttpService:JSONDecode(Response.Body))
    end;

    function Webhook:ChangeAvatar(Webhook, Avatar)
        local Success, Error = pcall(function()
            Request({
                Url = Webhook,
                Method = "PATCH",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode({
                    avatar = Avatar
                })
            })
        end)

        if not Success then
            error(Error)
        else
            Network:Notify("Success", "Changed webhook avatar", 5)
        end
    end;

    function Webhook:DeleteWebhook(Webhook)
        local Success, Error = pcall(function()
            Request({
                Url = Webhook,
                Method = "DELETE",
                Headers = {
                    ["Content-Type"] = "application/json"
                }
            })
        end)

        if not Success then
            error(Error)
        else
            Network:Notify("Success", "Deleted webhook", 5)
        end
    end;

    function Webhook:ChangeSettings(Setting, Value)
        local Success, Error = pcall(function()
            WebhookSettings[Setting] = Value
        end)

        if not Success then
            error(Error)
        else
            Network:Notify("Success", string.format("Changed webhook setting %s to %s", Setting, tostring(Value)), 5)
        end
    end;

    function Webhook:SaveWebhook(Webhook, Path)
        writefile(Path, Webhook)
        Network:Notify("Success", "Saved webhook", 5)
    end;

    function Webhook:LoadWebhook(Path)
        local Webhook, Exists = nil, false;

        if isfile(Path) then
            Webhook = readfile(Path)

            local Response,_ = Request({
                Url = Webhook,
                Method = "GET",
                Headers = {
                    ["Content-Type"] = "application/json"
                }
            })

            if Response then
                Exists = true;
            else
                Exists = false;
                Network:Notify("Error", "The saved webhook is invalid, please enter a new one and save it", 5)
            end

            Network:Notify("Success", "Loaded webhook", 5)
        else
            Network:Notify("Error", "No saved webhook found", 5)
            Exists = false;
        end

        return Webhook, Exists
    end;
end
return Webhook
