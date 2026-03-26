# Motor Referans Belgeleri

Bu dizin, oyun motoruna özgü API'lar, kalıplar ve en iyi uygulamalara ilişkin **seçilmiş, sürüme sabitlenmiş anlık görüntüler** içermektedir. Amacı, LLM bilgi kesme tarihini aşan motor sürümleri için doğru rehberlik sağlamaktır.

## Neden Bu Dizin Var

LLM'ler, motorun geliştikçe geçerliliğini yitiren API'lara sahip versiyonlarda eğitilir. Bu referans belgeleri LLM bilgisini **yenisiyle değiştirmez**, bunun yerine **tamamlar**: belgelerin motor API'larının doğru ve güncel olmasını sağlamak amacıyla ajan sistemine bağlanır.

## Yapı

```
engine-reference/
├── README.md              # Bu dosya
├── godot/
│   ├── VERSION.md         # Sürüm sabitleme ve bilgi kesme uyarıları
│   ├── breaking-changes.md
│   ├── deprecated-apis.md
│   ├── current-best-practices.md
│   └── modules/           # Alt sistemlere göre: animation, audio, input, vb.
├── unity/
│   ├── VERSION.md
│   ├── PLUGINS.md         # Önemli eklentiler (Addressables, DOTS, vb.)
│   ├── breaking-changes.md
│   ├── deprecated-apis.md
│   ├── current-best-practices.md
│   ├── modules/
│   └── plugins/
└── unreal/
    ├── VERSION.md
    ├── PLUGINS.md
    ├── breaking-changes.md
    ├── deprecated-apis.md
    ├── current-best-practices.md
    ├── modules/
    └── plugins/
```

## Bu Belgeler Nasıl Kullanılır

Motor uzmanı ajanları (`godot-specialist`, `unity-specialist`, `unreal-specialist`) ve ilgili alt uzmanlar, otomatik olarak `VERSION.md` dosyasını ve bu dizindeki ilgili modül belgelerini okur. Bu, ajanların motor API'larını güvenle önerebilmesini sağlar.

API konusunda emin olmayan herhangi bir ajan:
1. Önce `VERSION.md` dosyasını kontrol etmeli
2. Ardından ilgili modül dosyasına başvurmalı
3. Emin değilse kullanıcıyı doğrulamaya yönlendirmeli

## Bakım

Bu belgeler statik değildir. Motor sürümleri yükseltildiğinde veya yeni önemli API'lar keşfedildiğinde güncellenmelidir. Her dosya en üstte `VERSION.md` bağlantısı içerir.
