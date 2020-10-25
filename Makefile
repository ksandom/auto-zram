install:
	cp bin/auto-zram /usr/bin/auto-zram
	cp config/systemd/auto-zram.service /etc/systemd/system/
	cp config/auto-zram.sh /etc/auto-zram.sh
	systemctl daemon-reload
	systemctl enable auto-zram.service
	systemctl start auto-zram.service
	systemctl status auto-zram.service || true

uninstall:
	systemctl stop auto-zram.service
	systemctl disable auto-zram.service
	rm /usr/bin/auto-zram /etc/systemd/system/auto-zram.service /etc/auto-zram.sh
	systemctl daemon-reload
	make uninstallMonitor

installMonitor:
	cp config/systemd/auto-zram-monitor.service /etc/systemd/system/
	cp config/systemd/auto-zram-monitor.timer /etc/systemd/system/
	systemctl daemon-reload
	systemctl enable auto-zram-monitor.service
	systemctl enable auto-zram-monitor.timer
	systemctl stop auto-zram-monitor.service
	systemctl start auto-zram-monitor.service
	systemctl start auto-zram-monitor.timer

uninstallMonitor:
	rm -f /etc/systemd/system/ /etc/systemd/system/ auto-zram-monitor.service auto-zram-monitor.timer
	systemctl daemon-reload
	systemctl disable auto-zram-monitor.service
	systemctl stop auto-zram-monitor.service
	systemctl disable auto-zram-monitor.timer
	systemctl stop auto-zram-monitor.timer
