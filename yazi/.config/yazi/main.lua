-- ~/.config/yazi/init.lua
-- See https://github.com/dedukun/bookmarks.yazi
require("bookmarks"):setup({
    save_last_directory = true,
    persist = "all",
    desc_format = "full",
    notify = {
        enable = false,
        timeout = 1,
        message = {
            new = "New bookmark '<key>' -> '<folder>'",
            delete = "Deleted bookmark in '<key>'",
            delete_all = "Deleted all bookmarks",
        },
    },
})
