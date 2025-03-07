#!/bin/sh

apt update
apt install -y -V build-essential curl
apt install -y -V ca-certificates lsb-release wget
wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
apt install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
apt update
apt install -y -V libarrow-dev # For C++
apt install -y -V libarrow-glib-dev # For GLib (C)
apt install -y -V libarrow-dataset-dev # For Apache Arrow Dataset C++
apt install -y -V libarrow-dataset-glib-dev # For Apache Arrow Dataset GLib (C)
apt install -y -V libarrow-acero-dev # For Apache Arrow Acero
apt install -y -V libarrow-flight-dev # For Apache Arrow Flight C++
apt install -y -V libarrow-flight-glib-dev # For Apache Arrow Flight GLib (C)
apt install -y -V libarrow-flight-sql-dev # For Apache Arrow Flight SQL C++
apt install -y -V libarrow-flight-sql-glib-dev # For Apache Arrow Flight SQL GLib (C)
apt install -y -V libgandiva-dev # For Gandiva C++
apt install -y -V libgandiva-glib-dev # For Gandiva GLib (C)
apt install -y -V libparquet-dev # For Apache Parquet C++
apt install -y -V libparquet-glib-dev # For Apache Parquet GLib (C)

apt install -y -V postgresql-server-dev-15
