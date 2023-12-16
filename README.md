# Demo für Docker: Webserver "nginx" in Container liefert eigene Webseite aus #

<br>

Das Repo enthält im Wurzelverzeichnis ein [Dockerfile](./Dockerfile), welches
das Image `nginx:latest` als Basis-Image verwendet.
Das Image enthält also als Betriebs-System [Debian Linux](https://www.debian.org/)
und den Webserver [nginx](https://nginx.org/en/).
Das `Dockerfile` kopiert den Web-Content aus dem Unterverzeichnis [docs/](docs/)
in den Ordner `/usr/share/nginx/html/` im Image, weil dies der Ordner für den von
`nginx` ausgelieferten Web-Content ist.

<br>

----

## Docker-Befehle ##

<br>

**Vorbemerkung:** Unter Linux müssen Sie für die folgenden Aufrufe von `docker` evtl. den Befehl `sudo` voranstellen.

<br>

Führen Sie den folgenden Befehl im Verzeichnis mit dem [Dockerfile](./Dockerfile) aus, um das Image zu erstellen:
```
docker build -t nginx4html:0.9 .
```
Hierbei ist `nginx4html` der Name des Images und `0.9` die Versionsnummer.

<br>

Nach einem erfolgreichen Lauf dieses Befehls sollte das neu erzeugte Image in der Liste aller lokalen Images,
die vom folgenden Befehl ausgegeben wird, enthalten sein:
```
docker image ls
```
Das `ls` steht für "list".

<br>

Wie können dann einen Container (laufende Instanz) von diesem Image erzeugen:
```
docker run --detach --name mein-webserver-1 -p 8080:80 nginx4html:0.9
```

Die Bedeutung der verwendeten Optionen und Argumente ist:
* `--detach` : Container wird im Hintergrund ausgeführt, blockiert also nicht die Shell, mit der der Befehl ausgeführt wurde
* `--name mein-webserver-1` : Name des Containers
* `-p 8080:80` : Der Port 80 des Containers soll an den Port 8080 des "äußeren" Betriebssystem gebunden werden
* `nginx4html:0.9`: Image, für das ein Container erzeugt werden soll.

<br>

Nach erfolgreicher Erzeugung sollte der Container in der Liste der laufenden Container, die der folgende Befehl ausgibt, enthalten sein:
```
docker container ls
```

<br>

Die Webseite aus dem Ordner [docs/](docs/) dieses Repos sollte dann unter der folgenden lokalen URL im Web-Browser erreichbar sein:
```
http://localhost:8080/
```

<br>

Mit dem folgenden Befehl können wir uns das aktuelle Log-File des Container anzeigen lassen:
```
docker container logs mein-webserver-1
```

<br>

Es ist auch möglich, eine interaktive Shell im Container zu öffnen:
```
docker exec --interactive --tty mein-webserver-1 sh
```
Hierbei ist das `sh` am Ende der im Container auszuführende Befehl, nämlich die Shell.

Geben Sie z.B. den folgenden Befehl in die so erzeugte interaktive Shell ein, um sich das Inhaltsverzeichnis mit dem Web-Content anzeigen zu lassen:
```
ls -l /usr/share/nginx/html/
```

Wir können mit dem folgenden Befehl eine Datei mit dem aktuellen Datum und Uhrzeit
im Container erzeugen:
```
date > /root/datum.txt
```

Sie können noch weitere Linux-Befehl eingeben oder die interaktive Shell mit dem Befehl `exit` verlassen.

<br>

Während ein oder mehrere Container laufen, können Sie mit dem folgenden Befehl den Ressourcenverbrauch (z.B. CPU und RAM) der einzelnen Container anzeigen lassen:
```
docker container stats
```

Die in dem Container laufenden Prozesse können Sie sich mit dem folgenden Befehl ausgeben lassen:
```
docker container top mein-webserver-1
```

Der folgende Befehl listet die Dateien auf, welche sich im Container im Vergleich zu Image geändert haben:
```
docker container diff mein-webserver-1
```

<br>

Wie können dann den Container mit dem folgenden Befehl beenden:
```
docker container stop mein-webserver-1
```

<br>

Die Ausgabe des folgenden Befehls zeigt, dass der gestoppte Container immer noch vorhanden ist:
```
docker container ls --all
```
Die Option `--all` ist herbei erforderlich, damit auch gestoppte Container angezeigt werden.

<br>

Wie können den Container mit folgendem Befehl wieder starten:
```
docker container start mein-webserver-1
```
Dabei müssen wir das Port-Forwarding nicht erneut spezifizieren.

Wenn wir erneut eine interaktive Shell zum Container öffnen, dann können wir uns mit dem folgenden Befehl die während des vorherigen Laufs erzeugte Datei `datum.txt` anzeigen lassen:
```
cat /root/datum.txt
```
Dies zeigt, dass die im Container geänderten Dateien auch erhalten bleiben, wenn der Container gestoppt und neu gestartet wird.

Die Datei `/root/datum.txt` aus dem Container können Sie sich mit dem folgenden Befehl aus dem Container herauskopieren:
```
docker container cp mein-webserver-1:/root/datum.txt datum-aus-container.txt
```

<br>

Wir stoppen den Container erneut mit dem selben Befehl wie oben.

Der gestoppte Container kann mit folgendem Befehl gelöscht werden:
```
docker container rm mein-webserver-1
```

Um *ALLE* gestoppten Container zu löschen kann der folgende Befehl eingegeben werden (gefährlich!):
```
docker container prune
```

<br>

----

## Image auf *Docker Hub* veröffentlichen ##

<br>

Wenn Sie das Image auf [Docker Hub](https://hub.docker.com/) veröffentlichen möchten, dann gehen Sie wie folgt beschrieben vor.
Sie können aber auch die [offizielle Dokumentation](https://docs.docker.com/get-started/04_sharing_app/) lesen.

Legen Sie sich ein (kostenloses) Konto auf *Docker Hub* an.
Hierbei müssen Sie einen Nutzernamen festlegen.
Im weiteren Beispiel ist dieser `mide76`.

Legen Sie sich auf der Weboberfläche ein Repository an.
Dieser Repo-Name ist für das weitere Beispiel `nginx4html`.

Geben Sie den folgenden Befehl ein, um dem Image den Namen `mide76/nginx4html` zu geben (also `<nutzer>/<reponame>`):
```
docker tag nginx4html mide76/nginx4html
```

Loggen Sie sich dann auf der Konsole mit Ihrem Docker-Konto ein:
```
docker login
```

Sie können dann das Image mit folgendem Befehl auf den Server hochladen:
```
docker push mide76/nginx4html
```

Öffentliche URL des Beispiel-Repos: https://hub.docker.com/r/mide76/nginx4html

Andere Nutzer können die neueste Version dieses Image dann mit dem folgenden Befehl herunterladen:
```
docker pull mide76/nginx4html:latest
```

<br>

----

## License ##

<br>

See the [LICENSE file](LICENSE.md) for license rights and limitations (BSD 3-Clause License).

<br>
