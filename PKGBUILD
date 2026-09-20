# Maintainer: Your Name <you@example.com>
pkgname=dev-toolkit
pkgver=0.3.0
pkgrel=1
pkgdesc='Quick developer setup after switching Linux distro: pick toolkits, tweak with add/del'
arch=('any')
url='https://github.com/S00what/dev-toolkit'
license=('GPL-3.0-or-later')
depends=('bash' 'gawk')
optdepends=('sudo: install packages as a normal user')
source=("$pkgname-$pkgver.tar.gz::$url/archive/refs/tags/v$pkgver.tar.gz")
sha256sums=('SKIP')   # replace with the real checksum: updpkgsums

package() {
    cd "$pkgname-$pkgver"
    make DESTDIR="$pkgdir" PREFIX=/usr install
}
