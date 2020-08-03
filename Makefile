install:
	cp bin/auto-zram /usr/bin/auto-zram
	cp config/systemd.service /etc/systemd/system/auto-zram.service
	systemctl daemon-reload
	systemctl enable auto-zram.service
	systemctl start auto-zram.service
	systemctl status auto-zram.service || true

uninstall:
	systemctl stop auto-zram.service
	systemctl disable auto-zram.service
	rm /usr/bin/auto-zram /etc/systemd/system/auto-zram.service
	systemctl daemon-reload
