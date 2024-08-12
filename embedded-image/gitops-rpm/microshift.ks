lang en_US.UTF-8
keyboard us
timezone Etc/UTC --utc
text
reboot

# Configure network to use DHCP and activate on boot
# Note I am using DHCP to set hostname, if you cannot do that and just want to
# to try things out simply add the --hostname to the end
network --bootproto=dhcp --device=link --activate --onboot=on

# Configure ostree
ostreesetup --nogpg --osname=rhel --remote=edge --url=file:///run/install/repo/ostree/repo --ref=rhel/9/x86_64/edge

# Configure disk, use 20 GB for root partition
zerombr
clearpart --all --initlabel
part /boot/efi --fstype=efi --size=200
part /boot --fstype=xfs --asprimary --size=800
# Uncomment this line to add a SWAP partition of the recommended size
#part swap --fstype=swap --recommended
part pv.01 --grow
volgroup rhel pv.01
logvol / --vgname=rhel --fstype=xfs --size=20000 --name=root

################ Post Configuration #################

%post --log=/var/log/anaconda/post-install.log --erroronfail

# Configure ingress DNS for Microshift
cat > /etc/microshift/config.yaml
dns:
  baseDomain: microshift.ocplab.com
EOF

# Add the pull secret to CRI-O and set root user-only read/write permissions
cat > /etc/crio/openshift-pull-secret << EOF
{"auths":{"cloud.openshift.com":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2dudW5ucmVkaGF0Y29tMWVhczlyZHdsMm0yZWFyb21pbTNtcmt3a2ZqOkRENzM2R0dNN1pTR0dQQ1FDWVZYTTdNQVRENDE2QVk0WUE0U1pPRDVSTzRCMUw0NFBRT0MxSEdFREVWQlIxUEQ=","email":"gnunn@redhat.com"},"quay.io":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K2dudW5ucmVkaGF0Y29tMWVhczlyZHdsMm0yZWFyb21pbTNtcmt3a2ZqOkRENzM2R0dNN1pTR0dQQ1FDWVZYTTdNQVRENDE2QVk0WUE0U1pPRDVSTzRCMUw0NFBRT0MxSEdFREVWQlIxUEQ=","email":"gnunn@redhat.com"},"registry.connect.redhat.com":{"auth":"ODAyOTE4N3x1aGMtMUVBczlSZHdsMk0yZWFST01JTTNtUmtXS0ZKOmV5SmhiR2NpT2lKU1V6VXhNaUo5LmV5SnpkV0lpT2lJek1tWmhZV00xTmpaaU4ySTBaV0kyT1dZNU56azVOVEE1TkRreFpUTXhPQ0o5LkF3RUJWY3E2bWo0NlZOdmpkZXpJSmtqQzBvc0h4Y1pGYnhub2dTeGJpS19XUFBfZVhydUVDSWhrUlpTQjU3NTVTYmpzWGV6UkVPYzY5MVl3OWxJYnZSRzRLeU5DcVVqR2ZjUlQxNHhabkxETExGWHQ1NFJkSnVja1Q1WnhUUFMwS3prRGJwUEFUZUFfMUlPSFN1blcxeW9MQnBwcjItWldiV3l0c0ZlTllBRWxaNWxYZHpyTk1TU25xVjctZlBGM08xU1VaX1JIWVBQZjJQc2ZLVlQ5dGFTazZuUzFYa2pWYWlvX0hQbF9qRlJ1ME9oanc3NHRqRkFiVUJwd2R5QzJYMlg5RnFsTFplZDFWLUQtU3ptOEZjQlBVckpXUnVSUlNqenNzREJkNWVfaWhXR0VhZXRQcURsem1ZTE02YUw4VnZ1eEtmenpwS01OdTVQdEl3STV5Q0VaaUxYWFlVZl9FcDJESllJNTczQ1BycXF4YmsyaGpEWWhmSkpJWkFJWDRLZFNMQmdoZS0yUk90NnM2aWNIVDR2dkJwTWJJWFNIb3NpZWZRZHg4QUNJaVlkZkZSQmtxQVVkRFlYbWNVZzIxc2tRUUsxYWRDRFR6WHN5alB5cUE5THBKM3R0OVpSdGhab1F4cG5YYUU0M29BcENEQmpEOVdnbUlENko4OE1UOEIwRjBnLS1oYlAyYjhNTlpLRFhMSVZGaWJhemp4by1sWVpEdlVnQktDRWNFSnN4a01RMHUtQU00V00xZloyR1JuRzhVZFZSQUx2X1NSTW54eXFkNG9UUFJNQ2Nod0QxRXYyV2FyNnpqZHl5V0E3dm03ZkdzVWl1MEYyblhlOFJnb0Y4VXktd0FzWnB1X2JVZVlnajZRWnhNVC1KSFg2RXp6RTJKU2hzeGZv","email":"gnunn@redhat.com"},"registry.redhat.io":{"auth":"ODAyOTE4N3x1aGMtMUVBczlSZHdsMk0yZWFST01JTTNtUmtXS0ZKOmV5SmhiR2NpT2lKU1V6VXhNaUo5LmV5SnpkV0lpT2lJek1tWmhZV00xTmpaaU4ySTBaV0kyT1dZNU56azVOVEE1TkRreFpUTXhPQ0o5LkF3RUJWY3E2bWo0NlZOdmpkZXpJSmtqQzBvc0h4Y1pGYnhub2dTeGJpS19XUFBfZVhydUVDSWhrUlpTQjU3NTVTYmpzWGV6UkVPYzY5MVl3OWxJYnZSRzRLeU5DcVVqR2ZjUlQxNHhabkxETExGWHQ1NFJkSnVja1Q1WnhUUFMwS3prRGJwUEFUZUFfMUlPSFN1blcxeW9MQnBwcjItWldiV3l0c0ZlTllBRWxaNWxYZHpyTk1TU25xVjctZlBGM08xU1VaX1JIWVBQZjJQc2ZLVlQ5dGFTazZuUzFYa2pWYWlvX0hQbF9qRlJ1ME9oanc3NHRqRkFiVUJwd2R5QzJYMlg5RnFsTFplZDFWLUQtU3ptOEZjQlBVckpXUnVSUlNqenNzREJkNWVfaWhXR0VhZXRQcURsem1ZTE02YUw4VnZ1eEtmenpwS01OdTVQdEl3STV5Q0VaaUxYWFlVZl9FcDJESllJNTczQ1BycXF4YmsyaGpEWWhmSkpJWkFJWDRLZFNMQmdoZS0yUk90NnM2aWNIVDR2dkJwTWJJWFNIb3NpZWZRZHg4QUNJaVlkZkZSQmtxQVVkRFlYbWNVZzIxc2tRUUsxYWRDRFR6WHN5alB5cUE5THBKM3R0OVpSdGhab1F4cG5YYUU0M29BcENEQmpEOVdnbUlENko4OE1UOEIwRjBnLS1oYlAyYjhNTlpLRFhMSVZGaWJhemp4by1sWVpEdlVnQktDRWNFSnN4a01RMHUtQU00V00xZloyR1JuRzhVZFZSQUx2X1NSTW54eXFkNG9UUFJNQ2Nod0QxRXYyV2FyNnpqZHl5V0E3dm03ZkdzVWl1MEYyblhlOFJnb0Y4VXktd0FzWnB1X2JVZVlnajZRWnhNVC1KSFg2RXp6RTJKU2hzeGZv","email":"gnunn@redhat.com"}}}
EOF
chmod 600 /etc/crio/openshift-pull-secret

# Create a default core user, allowing it to run sudo commands without password
useradd -m -d /home/core -p \$5\$XZwaxsA5Giam7.iA\$0DAT7ky8HkvlEV4ueUdaKgLkd6/WCTofkiiHYrEyCl1 core
echo -e 'core\tALL=(ALL)\tNOPASSWD: ALL' > /etc/sudoers.d/core

# Install SSH key for core user
mkdir -m0700 /home/core/.ssh/
chown core:core /home/core/.ssh/

cat <<EOF >/home/core/.ssh/authorized_keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7xAiA1Si7t7lbYx7LK9ooFfPNbolStStdghBw6pDj3 gnunn@gnunn-book13
EOF

### set permissions
chmod 0600 /home/core/.ssh/authorized_keys
chown core:core /home/core/.ssh
chown core:core /home/core/.ssh/authorized_keys

### fix up selinux context
restorecon -R /home/core/.ssh/

# Configure the firewall with the mandatory rules for MicroShift
firewall-offline-cmd --zone=trusted --add-source=10.42.0.0/16
firewall-offline-cmd --zone=trusted --add-source=169.254.169.1

# Make the KUBECONFIG from MicroShift directly available for the root user
echo -e 'export KUBECONFIG=/var/lib/microshift/resources/kubeadmin/kubeconfig' >> /root/.profile

%end
