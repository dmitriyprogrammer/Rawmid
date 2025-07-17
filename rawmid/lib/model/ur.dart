class UrProfile {
  late String inn;
  late String company;
  late String oGrn;
  late String rs;
  late String bank;
  late String bik;
  late String kpp;
  late String urAddress;
  late String addressBuh;
  late String emailBuh;
  late String phoneBuh;
  late String edo;

  UrProfile({required this.inn, required this.company, required this.oGrn, required this.rs, required this.bank, required this.bik, required this.kpp, required this.urAddress, required this.addressBuh, required this.emailBuh, required this.phoneBuh, required this.edo});

  UrProfile.fromJson(Map<String, dynamic> json) {
    inn = json['inn'];
    company = json['company'];
    oGrn = json['ogrn'];
    rs = json['rs'];
    bank = json['bank'];
    bik = json['bik'];
    kpp = json['kpp'];
    urAddress = json['uraddress'];
    addressBuh = json['address_buh'];
    emailBuh = json['email_buh'];
    phoneBuh = json['phone_buh'];
    edo = json['edo'];
  }
}
