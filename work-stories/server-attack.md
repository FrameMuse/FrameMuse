# Server Attack

Here is the English translation of your text, keeping the technical context and natural, professional developer tone intact:

There was an incident on a project involving webhook processing. One day, the server started crashing due to memory exhaustion every 2-3 hours. It was just a straightforward OOM kill, and then the service would restart.

First, I went to check the metrics. The memory graph showed that consumption was growing linearly up to 100% and then dropping after a reboot. A typical leak. I looked at the logs right before a crash and noticed that the number of open connections to RabbitMQ was constantly increasing.

I started digging into it. It turned out that when a worker processed a message and an error occurred on the API side, the connection to the queue wasn't being closed in the catch block. Every error created a new connection but didn't close the old one. After 10,000 of these errors, the connections ate up all the memory, and the server crashed.

I fixed it in 30 minutes. I added a finally block where the connection was guaranteed to close. I also added a graceful shutdown so that all connections would terminate correctly upon reboot.

I wrote the post-mortem the next day. I outlined the timeline of when the crashes started, what triggered them, and how we found the root cause. I added action items: check all places where connections are opened, add a limit on the number of concurrent connections, and set up an alert for memory growth to get notified before a crash rather than after. Then, I ran a retro with the team so we wouldn't repeat these kinds of mistakes.

There was another incident. The server came under attack. CPU usage spiked to 100% and stayed there constantly. The services were running slowly, and users were complaining.

I quickly logged into the server and opened the logs. I saw thousands of authorization attempts from different IP addresses. Someone was brute-forcing passwords. Every attempt was straining the CPU because the server had to verify the credentials.

First, I expanded the available memory for the logs. The logs were filling up quickly due to the attack, and older entries were getting lost. This helped preserve more data for analysis.

Then, I set up fail2ban. I configured an auto-jail for IPs attempting to log in multiple times in a row. After 5 failed attempts, the IP was blocked automatically. The attacks continued, but the server stopped feeling the load.

I verified that no one had breached the server. I checked the logs for successful logins and made sure all active sessions were mine.

After the attack, I disabled password authentication entirely and switched to SSH keys. I also set up certificates for all logins.

Following these changes, the CPU never hit 100% again. Attacks still hit us occasionally, but fail2ban blocks them, and the server barely notices.
