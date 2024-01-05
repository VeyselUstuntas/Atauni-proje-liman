#!/bin/bash


# Atatürk Üniversitesi
# Açık Kaynak Yazılım Geliştirme 
#
# Proje
# Veysel Üstüntaş - 200707048
# 


log() {
    local log_message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $log_message" >> ./log_file.txt
}


echo "$islem"


if [ $# -eq 1 ]
then
	islem=$1
	log "Script başlatıldı - İşlem: $islem"	

	if [ "$islem" == "kur" ]
	then
	    log "Paket Kurulum İşlemi Başlatılıyor"

		NODE_MAJOR=18

		sudo apt update
		sudo apt install -y ca-certificates curl gnupg
		sudo mkdir -p /etc/apt/keyrings
		curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
		echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

		if [ $? -eq 0 ]
		then
			printf "\n"
			echo "Node Reposu Eklendi"
			printf "\n"

			log "Node Reposu Kuruldu"
			
			sudo apt install software-properties-common
			sudo add-apt-repository ppa:ondrej/php

			if [ $? -eq 0 ]
			then
				printf "\n"
				echo "PHP Reposu Eklendi"
				printf "\n"

				log "PHP Reposu Eklendi"

				sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
				wget -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > pgsql.gpg
				sudo mv pgsql.gpg /etc/apt/trusted.gpg.d/pgsql.gpg

				if [ $? -eq 0 ]
				then 
					printf "\n"
					echo "PostgreSQL Reposu Eklendi"
					printf "\n"

					log "PostgreSQL Reposu Eklendi"

					sudo apt update
					wget https://github.com/limanmys/core/releases/download/release.feature-new-ui.863/liman-2.0-RC2-863.deb
					apt install ./liman-2.0-RC2-863.deb

				else
					printf "\n"
					echo "PostgreSQL Reposu Eklenemedi"
					printf "\n"

					log "PostgreSQL Reposu Eklenemedi"
					
				fi

			else
				printf "\n"
				echo "PHP Reposu Eklenemedi"
				printf "\n"
				log "PHP Reposu Eklenemedi"

			fi
			
		else
			printf "\n"
			echo "Node Reposu Eklenemedi"
			printf "\n"
			log "Node Reposu Eklenemedi"
		fi


	elif [ "$islem" == "kaldır" ]
	then
		log "Kaldırma İşlemi Başlatıldı"
		sudo apt remove ./liman-2.0-RC2-863.deb
		sudo apt remove ca-certificates curl gnupg
		sudo apt remove software-properties-common
		rm -rf ./liman-2.0-RC2-863.deb

		if [ $? -eq 0 ]
		then 
			printf "\n"
			echo "\"liman-2.0-RC2-863.deb\" KALDIRILDI..."
			printf "\n"
			log "\"liman-2.0-RC2-863.deb\" KALDIRILDI..."
		else
			printf "\n"
			echo "\"liman-2.0-RC2-863.deb\" KALDIRILAMADI !!"
			printf "\n"
			log "\"liman-2.0-RC2-863.deb\" KALDIRILAMADI !!"
		fi

	elif [ "$islem" == "administrator" ] 
	then
		sudo limanctl administrator

		if [ $? -eq 0 ]
		then
			printf "\n"
			echo "Admin Şifresi Oluşturuldu"
			printf "\n"
			log "Admin Şifresi Oluşturuldu"
		else
			printf "\n"
        	echo "Admin Şifresi OLUŞTURULAMADI!"
        	printf "\n"
			log "Admin Şifresi OLUŞTURULAMADI!"
		fi

	elif [ "$islem" == "reset" ]
	then
		log "Şifre sıfırlama işlemi başlatıldı"
		sudo limanctl reset administrator@liman.dev
		printf "\n"
		if [ $? -eq 0 ]
		then 
			printf "\n"
			echo "Admin Kullanıcısı için Yeni Şifre Oluşturuldu"
			printf "\n"
			log "Admin Kullanıcısı için Yeni Şifre Oluşturuldu"
		else
			printf "\n"
			echo "Admin Kullanıcısı için Şifre OLUŞTURULAMADI!!"
			printf "\n"
			log "Admin Kullanıcısı için Şifre OLUŞTURULAMADI!!"
		fi

	elif [ "$islem" == "help"  ]
	then
	    log "Yardım mesajı görüntülendi"
		printf "\n"
		echo "sudo chmod u+x script.sh şekilde çalıştırma yetkisi verin."

		printf "\n"
		echo "\"./script.sh kur\" komutu ile kurulumu gerçekleştirin."
		printf "\n"
		echo "\"./script.sh kaldır\" komutu ile paketi kaldırabilirsiniz."
		printf "\n"
		echo "\"./script.sh administrator\" komutu ile admin kullanıcısının parolasını oluşturur."
		printf "\n"
		echo "\"./script.sh reset\" komutu ile admin kullanıcısi için yeni bir parola oluşturabilirsiniz."
		printf "\n"
	else
		log "GEÇERSİZ PARAMETRE \"$islem\""
		printf "\n"
		echo "GEÇERSİZ PARAMETRE GİRİLDİ"
		printf "\n"
	fi
elif [ $# -lt 1 ]
then
    log "Parametre eksik. Lütfen geçerli bir işlem belirtin."
	printf "\n"
	echo "LÜTFEN YAPACAĞINIZ İŞLEMİ PARAMETRE VEREREK BELİRTİNİZ"
	printf "\n"
else
	printf "\n"
	echo "BU SCRIPT KOMUT SATIRINDAN EN FAZLA BİR PARAMETRE ALABİLİR..."
	printf "\n"
fi
