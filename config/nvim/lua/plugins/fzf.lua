return {
    {
        "junegunn/fzf",
        -- build = "fzf#install()"
        -- name = "fzf",
        -- dir = "/usr/share/vim/vimfiles/plugin"
        --dir = "~/.fzf",
        --build = "./install --all",
    },
    {
        "junegunn/fzf.vim",
        dependencies = {  "junegunn/fzf" },
    }
}
