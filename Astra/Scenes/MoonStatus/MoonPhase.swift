//
//  MoonPhase.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import Foundation

enum MoonPhase: String, CaseIterable {
    case newMoon = "Yeni Ay"
    case fullMoon = "Dolunay"
    case firstQuarter = "İlk Dördün"
    case lastQuarter = "Son Dördün"
    
    var emoji: String {
        switch self {
        case .newMoon:
            return "🌑"
        case .fullMoon:
            return "🌕"
        case .firstQuarter:
            return "🌓"
        case .lastQuarter:
            return "🌗"
        }
    }
    
    var freeDescription: String {
        switch self {
        case .newMoon:
            return "Yeni Ay, niyet koymak ve yeni başlangıçlar için uygun bir enerjiyi temsil eder."
        case .fullMoon:
            return "Dolunay, tamamlanma ve farkındalık enerjisinin ön planda olduğu bir dönemdir."
        case .firstQuarter:
            return "İlk Dördün, harekete geçme ve karar alma enerjisini simgeler."
        case .lastQuarter:
            return "Son Dördün, bırakma ve içsel değerlendirme zamanını temsil eder."
        }
    }
    
    var premiumDescription: String {
        switch self {
        case .newMoon:
            return "Yeni Ay, içe dönme ve geleceğe dair niyetlerini netleştirme zamanıdır. Bu dönemde zihinsel gürültü azalabilir ve iç ses daha net duyulabilir. Yeni hedefler belirlemek, alışkanlıkları gözden geçirmek ve hayatında neyi büyütmek istediğini fark etmek için uygun bir süreçtir. Acele etmek yerine, küçük ama bilinçli adımlar atmak bu enerjiden en iyi şekilde yararlanmanı sağlar."
        case .fullMoon:
            return "Dolunay, görünmeyen duyguların ve yarım kalan konuların daha belirgin hale geldiği bir süreçtir. Bu dönemde içsel farkındalık artabilir ve bazı konular netlik kazanabilir. Duygusal hassasiyet yükselirken, geçmişte ertelenen kararlar yeniden gündeme gelebilir. Dolunay enerjisi, bitmesi gerekenleri fark etmek ve içsel dengeyi yeniden kurmak için güçlü bir zaman sunar."
        case .firstQuarter:
            return "İlk Dördün, niyetlerin somut adımlara dönüşmeye başladığı bir evredir. Kararsızlıklar azalabilir ve eyleme geçme isteği artabilir. Bu dönemde karşılaşılan küçük engeller, doğru yönde ilerleyip ilerlemediğini fark etmeni sağlar. Sabırlı ve kararlı olmak, sürecin verimli ilerlemesine yardımcı olur."
        case .lastQuarter:
            return "Son Dördün, tamamlanmış döngüleri geride bırakma ve zihinsel arınma sürecidir. Bu dönemde gereksiz yükler, alışkanlıklar veya düşünceler daha görünür hale gelebilir. Kendinle yüzleşmek, dinlenmek ve içsel dengeyi yeniden sağlamak için uygun bir zamandır. Yavaşlamak ve gözlemlemek, bir sonraki yeni aya daha güçlü girmeni sağlar."
        }
    }
    
    var impactAreas: [(emoji: String, title: String)] {
        switch self {
        case .newMoon:
            return [
                ("🎯", "Niyet ve hedef belirleme"),
                ("🧠", "İçsel farkındalık"),
                ("🌱", "Yeni başlangıçlara hazırlık"),
                ("📓", "Planlama & vizyon")
            ]
        case .fullMoon:
            return [
                ("💭", "Duygusal farkındalık"),
                ("🔍", "Netleşme & sonuç alma"),
                ("❤️", "İlişkiler ve iletişim"),
                ("🧘", "Denge ve farkındalık")
            ]
        case .firstQuarter:
            return [
                ("🚀", "Harekete geçme"),
                ("🛠", "Karar alma süreçleri"),
                ("📈", "Çaba & gelişim"),
                ("🔥", "Motivasyon artışı")
            ]
        case .lastQuarter:
            return [
                ("🧹", "Bırakma & sadeleşme"),
                ("🌙", "İçe dönüş"),
                ("🧘", "Dinlenme & toparlanma"),
                ("🔁", "Alışkanlıkları gözden geçirme")
            ]
        }
    }
    
    var effectDuration: String {
        switch self {
        case .newMoon:
            return "Etki süresi:\n Yaklaşık 2–3 gün."
        case .fullMoon:
            return "Etki süresi:\n Yaklaşık 2–3 gün"
        case .firstQuarter:
            return "Etki süresi:\n Yaklaşık 2 gün."
        case .lastQuarter:
            return "Etki süresi:\n Yaklaşık 2 gün"
        }
    }
    
    var premiumContent: (love: String, work: String, ritual: String) {
        switch self {
        case .newMoon:
            return (
                love: "Yeni Ay döneminde ilişkilerde yeni başlangıçlar ve niyetler öne çıkabilir. Bu süreçte kendinle ve partnerinle daha derin bağlantılar kurmak için uygun bir zaman olabilir. İletişimde netlik ve samimiyet önemli olabilir.",
                work: "İş hayatında yeni projeler ve hedefler belirlemek için uygun bir dönem olabilir. Odaklanma ve planlama konularında daha net bir zihin durumu yaşayabilirsin. Küçük ama anlamlı adımlar atmak bu enerjiden yararlanmanı sağlayabilir.",
                ritual: "Yeni Ay ritüeli: Bu akşam sessiz bir ortamda, bir kağıda gelecek dönem için 3-5 niyetini yaz. Her niyetin altına küçük bir eylem adımı ekle. Kağıdı mum ışığında oku ve içsel olarak bu niyetleri kabul et."
            )
        case .fullMoon:
            return (
                love: "Dolunay döneminde ilişkilerdeki duygusal dinamikler daha görünür hale gelebilir. Bu süreçte iletişimde netlik ve karşılıklı anlayış önemli olabilir. Geçmişte ertelenen konuşmalar gündeme gelebilir ve çözüm bulmak için uygun bir zaman olabilir.",
                work: "İş hayatında tamamlanması gereken projeler ve alınması gereken kararlar öne çıkabilir. Bu dönemde netleşme ve sonuç alma konularında daha güçlü bir enerji yaşayabilirsin. Önemli kararlar için bu zamanı değerlendirebilirsin.",
                ritual: "Dolunay ritüeli: Bu akşam balkonda veya pencerede ay ışığını görebileceğin bir yerde dur. Geçmişte tamamladığın şeyleri düşün ve minnettarlıkla geride bırak. Sonra gelecek için 3 şükür ifadesi söyle."
            )
        case .firstQuarter:
            return (
                love: "İlk Dördün döneminde ilişkilerde harekete geçme ve somut adımlar atma enerjisi öne çıkabilir. Bu süreçte iletişimde netlik ve kararlılık önemli olabilir. İlişkilerinde ilerleme sağlamak için uygun bir zaman olabilir.",
                work: "İş hayatında eyleme geçme ve ilerleme kaydetme enerjisi güçlü olabilir. Bu dönemde kararlar almak ve projeleri ilerletmek için uygun bir zaman olabilir. Küçük engellerle karşılaşsan bile, sabırlı ve kararlı olmak sürecin verimli ilerlemesine yardımcı olabilir.",
                ritual: "İlk Dördün ritüeli: Bu akşam bir mum yak ve hedeflerini gözden geçir. Her hedef için bir sonraki somut adımı belirle ve bunları bir kağıda yaz. Mum sönerken bu adımları içsel olarak kabul et."
            )
        case .lastQuarter:
            return (
                love: "Son Dördün döneminde ilişkilerde bırakma ve sadeleşme süreci öne çıkabilir. Bu süreçte gereksiz yükler ve geçmişten kalan konular daha görünür hale gelebilir. İlişkilerinde dengeyi yeniden kurmak için uygun bir zaman olabilir.",
                work: "İş hayatında tamamlanmış döngüleri geride bırakma ve zihinsel arınma süreci öne çıkabilir. Bu dönemde gereksiz yükler ve verimsiz alışkanlıkları gözden geçirmek için uygun bir zaman olabilir. Dinlenmek ve toparlanmak önemli olabilir.",
                ritual: "Son Dördün ritüeli: Bu akşam sessiz bir ortamda otur ve geçmiş dönemde tamamladığın şeyleri düşün. Bir kağıda bırakmak istediğin alışkanlıkları veya düşünceleri yaz. Kağıdı güvenli bir şekilde yak veya yırt ve geride bırak."
            )
        }
    }
    
    // Basit bir ay fazı hesaplama (gerçek hesaplama için API gerekebilir)
    static func currentPhase() -> MoonPhase {
        // Şimdilik basit bir döngü kullanıyoruz
        // Gerçek uygulamada astronomik hesaplama veya API kullanılmalı
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: Date())
        
        // Basit bir yaklaşım: Ayın gününe göre faz belirleme
        // Bu gerçekçi değil ama placeholder olarak kullanılabilir
        switch dayOfMonth % 28 {
        case 0...6:
            return .newMoon
        case 7...13:
            return .firstQuarter
        case 14...20:
            return .fullMoon
        default:
            return .lastQuarter
        }
    }
}

