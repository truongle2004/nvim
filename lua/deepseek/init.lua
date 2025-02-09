local https = require("ssl.https")
local ltn12 = require("ltn12")
local cjson = require("cjson")
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event


local popup = Popup({
  enter = true,
  focusable = true,
  border = {
    style = "rounded",
  },
  position = "50%",
  size = {
    width = "80%",
    height = "80%"
  }
})

popup.mount("deepseek")

popup.on(event.BufLeave, function()
  popup:unmount()
end)

vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { "hello world" })



--
-- local request_data = {
--   model = "deepseek/deepseek-chat",
--   messages = {
--     { role = "user", content = "what is deepseek" }
--   }
-- }
--
-- local request_body = cjson.encode(request_data)
-- local response_body = {}
--
-- local result, status_code, response_headers = https.request {
--   url = "https://openrouter.ai/api/v1/chat/completions", -- Replace with the actual API endpoint
--   method = "POST",
--   headers = {
--     ["Content-Type"] = "application/json",
--     ["Content-Length"] = tostring(#request_body),
--     ["Authorization"] = "Bearer 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"
--   },
--   source = ltn12.source.string(request_body),
--   sink = ltn12.sink.table(response_body)
-- }
--
-- -- print("Status Code:", status_code)
-- -- print("Response Body:", table.concat(response_body))
--
-- local response_string = table.concat(response_body)
-- -- Parse JSON into a Lua table
-- local success, json_data = pcall(cjson.decode, response_string)
--
-- if success then
--     if json_data.choices then
--       for i, choice in ipairs(json_data.choices) do
--         print("Choice " .. i .. ": " .. choice.message.content)
--       end
--     end
-- else
--   print("Failed to parse JSON:", json_data)
-- end
