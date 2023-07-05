class User {
  final String nama;
  final String email;
  final String password;
  final String status;
  final String image;

  User({
    required this.nama,
    required this.email,
    required this.password,
    required this.status,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'password': password,
      'status': status,
      'image': image,
    };
  }

  factory User.FromMap(Map<String, dynamic> data) {
    return User(
      nama: data['nama'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      status: data['status'] ?? '',
      image: data['image'] ?? '',
    );
  }
}

class Kategori {
  final String id_kategori;
  final String nama_kategori;

  Kategori({required this.id_kategori, required this.nama_kategori});

  Map<String, dynamic> toMap() {
    return {
      'id_kategori': id_kategori,
      'nama_kategori': nama_kategori,
    };
  }

  factory Kategori.FromMap(Map<String, dynamic> data) {
    return Kategori(
      id_kategori: data['id_kategori'] ?? '',
      nama_kategori: data['nama_kategori'] ?? '',
    );
  }
}

class Penanda {
  final String id_penanda;
  final String penanda;

  Penanda({
    required this.id_penanda,
    required this.penanda,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_penanda': id_penanda,
      'penanda': penanda,
    };
  }

  factory Penanda.FromMap(Map<String, dynamic> data) {
    return Penanda(
      id_penanda: data['id_penanda'] ?? '',
      penanda: data['penanda'] ?? '',
    );
  }
}

class Resep {
  final String id_resep;
  final String id_menu;
  final String id_kategori;
  final String username;
  final String bahan;
  final String deskripsi;
  final String image;

  Resep({
    required this.id_resep,
    required this.username,
    required this.bahan,
    required this.deskripsi,
    required this.id_menu,
    required this.id_kategori,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_resep': id_resep,
      'username': username,
      'bahan': bahan,
      'deskripsi': deskripsi,
      'id_menu': id_menu,
      'id_kategori': id_kategori,
      'image': image,
    };
  }

  factory Resep.FromMap(Map<String, dynamic> data) {
    return Resep(
      id_resep: data['id_resep'] ?? '',
      username: data['username'] ?? '',
      bahan: data['bahan'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      id_menu: data['id_menu'] ?? '',
      id_kategori: data['id_kategori'] ?? '',
      image: data['image'] ?? '',
    );
  }
}
