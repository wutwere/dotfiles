export const NotifyPlugin = async ({ $ }) => {
    const isMac = process.platform === "darwin";
    const isWsl =
        process.platform === "linux" &&
        (Boolean(process.env.WSL_INTEROP) || Boolean(process.env.WSL_DISTRO_NAME));

    const notify = async () => {
        if (isMac) {
            await $`afplay /System/Library/Sounds/Glass.aiff`;
            return;
        }
        if (isWsl) {
            await $`powershell.exe -c "[System.Media.SystemSounds]::Asterisk.Play()"`;
            return;
        }
    };

    return {
        event: async ({ event }) => {
            if (
                event.type === "session.idle" ||
                event.type === "permission.asked" ||
                event.type === "session.error"
            ) {
                await notify();
            }
        },
        "tool.execute.before": async (input) => {
            if (input.tool === "question") {
                await notify();
            }
        },
    };
};
