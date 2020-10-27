install:
	cp bin/auto-zram /usr/bin/auto-zram
	cp config/systemd/auto-zram.service /etc/systemd/system/
	mkdir -p /etc/auto-zram
	cp config/auto-zram.sh /etc/auto-zram/config
	
	systemctl daemon-reload
	
	systemctl enable auto-zram.service
	systemctl start auto-zram.service
	
	auto-zram status

uninstall:
	systemctl stop auto-zram.service
	systemctl disable auto-zram.service
	
	rm -f /usr/bin/auto-zram /etc/systemd/system/auto-zram.service /etc/auto-zram/config
	rm -Rf /etc/auto-zram/
	
	systemctl daemon-reload
	
	make uninstall-monitorRepeat || true
	make uninstall-monitorRepeatLoop || true

install-monitorLoop:
	cp config/systemd/auto-zram-monitorLoop.service /etc/systemd/system/
	
	systemctl daemon-reload
	
	systemctl enable auto-zram-monitorLoop.service
	systemctl start auto-zram-monitorLoop.service

uninstall-monitorLoop:
	systemctl stop auto-zram-monitorLoop.service
	systemctl disable auto-zram-monitorLoop.service
	
	rm /etc/systemd/system/auto-zram-monitorLoop.service
	
	systemctl daemon-reload

install-monitorRepeat:
	cp config/systemd/auto-zram-monitorRepeat.service /etc/systemd/system/
	cp config/systemd/auto-zram-monitorRepeat.timer /etc/systemd/system/
	
	systemctl daemon-reload
	
	systemctl enable auto-zram-monitorRepeat.service
	systemctl enable auto-zram-monitorRepeat.timer
	systemctl stop auto-zram-monitorRepeat.service
	systemctl start auto-zram-monitorRepeat.service
	systemctl start auto-zram-monitorRepeat.timer

uninstall-monitorRepeat:
	
	systemctl disable auto-zram-monitorRepeat.timer
	systemctl stop auto-zram-monitorRepeat.timer
	systemctl disable auto-zram-monitorRepeat.service
	systemctl stop auto-zram-monitorRepeat.service
	
	rm -f /etc/systemd/system/auto-zram-monitorRepeat.service /etc/systemd/system/auto-zram-monitorRepeat.timer
	
	systemctl daemon-reload

install-monitor:
	make install-monitorLoop

uninstall-monitor:
	make uninstall-monitorLoop
