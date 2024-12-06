# Demo für Docker: Webserver "nginx" in Container liefert eigene Webseite aus #

<br>

Das Repo enthält im Wurzelverzeichnis ein [Dockerfile](./Dockerfile), welches
das Image [nginx:stable-alpine3.17-slim](https://hub.docker.com/_/nginx/tags)
als Basis-Image verwendet.
Das Image enthält also als Betriebs-System [Alpine Linux](https://www.alpinelinux.org/)
und den Webserver [nginx](https://nginx.org/en/); bei *Alpine Linux* handelt
es sich um eine besonders leichtgewichtige Linux-Distribution, die sich besonders
gut als Grundlage für Container eignet.
Das `Dockerfile` kopiert den Web-Content aus dem Unterverzeichnis [docs/](docs/)
in den Ordner `/usr/share/nginx/html/` im Image, weil dies der Ordner für den von
`nginx` ausgelieferten Web-Content ist.

<br>

----

## Docker-Befehle ##

<br>

**Vorbemerkung:** Unter Linux müssen Sie für die folgenden Aufrufe von `docker` evtl. den Befehl `sudo` voranstellen.

<br>

### Erzeugung Image ###

Führen Sie den folgenden Befehl im Verzeichnis mit dem [Dockerfile](./Dockerfile) aus, um das Image zu erstellen:
```
docker build -t mide76/hallodocker:1.0 .
```
* Hierbei ist `mide76` der Nutzername auf *Docker Hub*.
  Wenn Sie das Image nicht auf *Docker Hub* veröffentlichen wollen (siehe unten),
  dann können Sie das `mide76/` weglassen.
  Wenn Sie das Image aber veröffentlichen wollen, dann müssen Sie `mide76`
  durch Ihren eigenen Nutzernamen auf *Docker Hub* veröffentlichen.
* `hallodocker` ist der Name des Images.
  Er darf keine Großbuchstaben enthalten.
* `1.0` ist die Version, die erstellt wird.
* Der einzelne Punkt '.' am Ende steht für das aktuelle Verzeichnis.
  Hier wird nach dem [Dockerfile](./Dockerfile) gesucht.
* [Doku für diesen Befehl](https://docs.docker.com/engine/reference/commandline/build/)

<br>

Nach einem erfolgreichen Lauf dieses Befehls sollte das neu erzeugte Image in der Liste aller lokalen Images,
die vom folgenden Befehl ausgegeben wird, enthalten sein:
```
docker image ls
```
* Das `ls` steht für "list".
* [Doku für dieses Befehl](https://docs.docker.com/engine/reference/commandline/image_ls/)

<br>

### Erzeugung Container ###

Wie können dann einen Container (laufende Instanz) von diesem Image erzeugen:
```
docker run --detach --name mein-webserver-1 -p 8080:80 mide76/hallodocker:1.0
```

Die Bedeutung der verwendeten Optionen und Argumente ist:
* `--detach` : Container wird im Hintergrund ausgeführt, blockiert also nicht die Shell, mit der der Befehl ausgeführt wurde
* `--name mein-webserver-1` : Name des Containers
* `-p 8080:80` : Der Port 80 des Containers soll an den Port 8080 des "äußeren" Betriebs-System gebunden werden
* `mide76/hallodocker:1.0`: Image, für das ein Container erzeugt werden soll.
* [Doku für diesen Befehl](https://docs.docker.com/engine/reference/commandline/run/)

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
[Doku für diesen Befehl](https://docs.docker.com/engine/reference/commandline/logs/)

<br>

### Interaktive Shell ###

Es ist auch möglich, eine interaktive Shell im Container zu öffnen:
```
docker exec --interactive --tty mein-webserver-1 sh
```
* Das `sh` am Ende ist der im Container auszuführende Befehl, nämlich die Shell.
* `--interactive`: Interaktive Ausführung
* `--tty`: Pseudo-Terminal erstellen
* [Doku für diesen Befehl](https://docs.docker.com/engine/reference/commandline/container_exec/)

<br>

<br>

Mit dem folgenden Befehl kann man sich den Inhalt des Verzeichnisses mit dem Web-Content ausgeben lassen:
```
ls -l /usr/share/nginx/html/
```
* `ls` steht für den Linux-Befehl "list" (entspricht in etwa dem DOS-Befehl `dir`)
* `-l`: Detaillierte Anzeige (nicht nur Dateiname, sondern z.B. auch noch Größe der Datei)
* [Doku zu diesem Befehl](https://www.digitalocean.com/community/tutorials/ls-command-in-linux-unix)

<br>

Wir können mit dem folgenden Befehl eine Datei mit dem aktuellen Datum und Uhrzeit
im Container erzeugen:
```
date > /root/datum.txt
```
Mit dem `>` wird die Ausgabe vom Programm `date` in eine Datei umgeleitet.

<br>

Sie können noch weitere Linux-Befehl eingeben oder die interaktive Shell mit dem Befehl `exit` verlassen.

<br>

### Überwachung laufender Container ###

Während ein oder mehrere Container laufen, können Sie mit dem folgenden Befehl den Ressourcenverbrauch (z.B. CPU und RAM) der einzelnen Container anzeigen lassen:
```
docker container stats
```
Abbruch dieser Anzeige mit `STRG+C`.

<br>

Die in dem Container laufenden Prozesse können Sie sich mit dem folgenden Befehl ausgeben lassen:
```
docker container top mein-webserver-1
```
[Doku für diesen Befehl](https://docs.docker.com/engine/reference/commandline/container_top/)

<br>

Der folgende Befehl listet die Dateien auf, welche sich im Container im Vergleich zu Image geändert haben:
```
docker container diff mein-webserver-1
```

<br>

### Container stoppen und neu starten ###

Wir können dann den Container mit dem folgenden Befehl beenden:
```
docker container stop mein-webserver-1
```
[Doku zu diesem Befehl](https://docs.docker.com/engine/reference/commandline/container_diff/)

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
[Doku zu diesem Befehl](https://docs.docker.com/engine/reference/commandline/container_start/)

Wenn wir erneut eine interaktive Shell zum Container öffnen, dann können wir uns mit dem folgenden Befehl die während des vorherigen Laufs erzeugte Datei `datum.txt` anzeigen lassen:
```
cat /root/datum.txt
```
Dies zeigt, dass die im Container geänderten Dateien auch erhalten bleiben, wenn der Container gestoppt und neu gestartet wird.
[Doku zu Linux-Befehl `cat`](https://linux.die.net/man/1/cat)

Die Datei `/root/datum.txt` aus dem Container können Sie sich mit dem folgenden Befehl aus dem Container herauskopieren:
```
docker container cp mein-webserver-1:/root/datum.txt datum-aus-container.txt
```
[Doku zu diesem Befehl](https://docs.docker.com/engine/reference/commandline/container_cp/)

<br>

### Container löschen ###

Wir stoppen den Container erneut mit dem selben Befehl wie oben.

Der gestoppte Container kann mit folgendem Befehl gelöscht werden:
```
docker container rm mein-webserver-1
```
[Doku zu diesem Befehl](https://docs.docker.com/engine/reference/commandline/container_rm/)

<br>

Um *ALLE* gestoppten Container zu löschen kann der folgende Befehl eingegeben werden (gefährlich!):
```
docker container prune
```
[Doku zu diesem Befehl](https://docs.docker.com/engine/reference/commandline/container_prune/)

<br>

----

## Image auf *Docker Hub* veröffentlichen ##

<br>

Wenn Sie das Image auf [Docker Hub](https://hub.docker.com/) veröffentlichen möchten, dann gehen Sie wie folgt beschrieben vor.
Sie können aber auch die [offizielle Dokumentation](https://docs.docker.com/get-started/04_sharing_app/) lesen.

<br>

### Erste Version veröffentlichen ###

Legen Sie sich ein (kostenloses) Konto auf *Docker Hub* an.
Hierbei müssen Sie einen Nutzernamen festlegen.
Im weiteren Beispiel ist dieser `mide76`.

Legen Sie sich auf der Weboberfläche ein Repository an.
Dieser Repo-Name ist für das weitere Beispiel `hallodocker`.

<br>

Loggen Sie sich dann auf der Konsole mit Ihrem Docker-Konto ein:
```
docker login
```
[Doku zu diesem Befehl](https://docs.docker.com/engine/reference/commandline/login/)

<br>

Sie können dann das Image mit folgendem Befehl auf den Server hochladen:
```
docker push mide76/hallodocker:1.0
```
[Doku zu diesem Befehl](https://docs.docker.com/engine/reference/commandline/push/)

<br>

Öffentliche URL des Beispiel-Repos: https://hub.docker.com/r/mide76/hallodocker

Andere Nutzer können des Image dann mit dem folgenden Befehl herunterladen:
```
docker pull mide76/hallodocker:1.0
```
[Doku für diesen Befehl](https://docs.docker.com/engine/reference/commandline/pull/)

<br>

### Weitere Version veröffentlichen ###

Wenn wir eine weitere Version des Image auf *Docker Hub* hochladen wollen (z.B. wegen Änderungen
in `Dockerfile` oder im verpackten Web-Content), dann können wir auch direkt das Image mit dem
Nutzernamen als Prefix erzeugen.
Für eine Version `1.1` sieht der Befehl wie folgt aus:
```
sudo docker build -t mide76/hallodocker:1.1 .
```

<br>

Der zugehörige `push`-Befehl sieht dann so aus:
```
docker push mide76/hallodocker:1.1
```

<br>

Es ist Konvention, der aktuellsten stabilen Version eines Images noch den Tag `latest` zu geben.
Dies können wir für die gerade erstellte Version `1.1` mit folgendem Befehl machen:
```
docker tag mide76/hallodocker:1.1 mide76/hallodocker:latest
```
[Doku zum Befehl](https://docs.docker.com/engine/reference/commandline/tag/)

<br>

Mit dem letzten Befehl wurde der Tag aber nur lokal angelegt.
Damit dieser Tag auch im Repositry auf *Docker Hub* verfügbar ist, muss
er gepusht werden:
```
docker push mide76/hallodocker:latest
```

<br>

Dieser Tag und die beiden Versionen werden dann im Tab "Tags" des Repos auf
*Docker Hub* angezeigt, siehe [hier](https://hub.docker.com/repository/docker/mide76/hallodocker/tags?page=1&ordering=last_updated).
Wenn zwei Tags den gleichen (Hash-)Wert für "Digest" haben, dann handelt es sich um dieselbe Version.

<br>

Wenn wir später noch eine Version `1.2` des Image erstellen, dann können wir mit dem folgenden
Befehl den Tag `latest` von der Version `1.1.` zu der Version `1.2.` verschieben:
```
docker tag mide76/hallodocker:1.2 mide76/hallodocker:latest
```
Durch Anhängen des Tag `latest` an eine andere Version wird der Tag von der bisherigen Version `1.1` entfernt.

Wir müssen dann noch das neue Image mit den beiden Tags `1.2` und `latest` zu *Docker Hub* pushen:
```
docker push mide76/hallodocker:1.2
docker push mide76/hallodocker:latest
```


<br>

----

## License ##

<br>

See the [LICENSE file](LICENSE.md) for license rights and limitations (BSD 3-Clause License).

<br>
