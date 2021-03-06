class Section < ApplicationRecord
    def self.load_data
        self.create(title: 'دانشکده ادبیات و علوم انسانی', mid: 41)
        self.create(title: 'دانشكده اقتصاد', mid: 44)
        self.create(title: 'دانشكده الهيات و معارف اسلامي', mid: 42)
        self.create(title: 'پرديس ابوريحان', mid: 73)
        self.create(title: 'پرديس البرز', mid: 15)
        self.create(title: 'پرديس ارس', mid: 10)
        self.create(title: 'پرديس كيش', mid: 25)
        self.create(title: 'پرديس دانشكده هاي فني', mid: 81)
        self.create(title: 'پرديس علوم', mid: 61)
        self.create(title: 'پرديس فارابي', mid: 22)
        self.create(title: 'پرديس كشاورزي و منابع طبيعي', mid: 71)
        self.create(title: 'پرديس هنرهاي زيبا', mid: 91)
        self.create(title: 'دانشكده تربيت بدني و علوم ورزشي', mid: 45)
        self.create(title: 'دانشكده جغرافيا', mid: 48)
        self.create(title: 'دانشكده حقوق و علوم سياسي', mid: 21)
        self.create(title: 'دانشكده دامپزشكي', mid: 75)
        self.create(title: 'دانشكده منابع طبيعي پرديس كشاورزي و منابع طبيعي', mid: 72)
        self.create(title: 'دانشكده روانشناسي و علوم تربيتي', mid: 51)
        self.create(title: 'دانشكده زبان ها و ادبيات خارجي', mid: 46)
        self.create(title: 'دانشكده علوم اجتماعي', mid: 31)
        self.create(title: 'دانشكده علوم اطلاعات و دانش شناسي', mid: 52)
        self.create(title: 'دانشكده علوم و فنون نوين', mid: 83)
        self.create(title: 'دروس عمومي', mid: 11)
        self.create(title: 'دانشكده كارآفريني', mid: 66)
        self.create(title: 'دانشكده محيط زيست', mid: 82)
        self.create(title: 'دانشكده مديريت', mid: 43)
        self.create(title: 'مركز تحقيقات بين المللي بيابان', mid: 74 )
        self.create(title: 'مركز تحقيقات بيوشيمي-بيوفيزيك', mid: 64)
        self.create(title: 'دانشكده مطالعات جهان', mid: 65)
        self.create(title: 'دانشكده معارف و انديشه اسلامي', mid: 47)
        self.create(title: 'موسسه ژئوفيزيك', mid: 62)
        self.create(title: 'موسسه منطقه اي آموزش عالي آب', mid: 80)
    end
end
