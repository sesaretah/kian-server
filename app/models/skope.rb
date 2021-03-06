class Skope < ApplicationRecord

    def self.find_by_user(user)
        utid  = user.email.split('@')[0]
        return Skope.where(utid: utid).first
    end

    def self.is_able?(user, section)
        flag =  false
        skope = self.find_by_user(user)
        p "$$$$$$"
        p section.id
        if !skope.blank? && !skope.sections.blank?
            p skope.sections
            p skope.sections.include?(section.id)
           flag = true if skope.sections.include?(section.id)
        end
        return flag
    end

    def self.user_sections(user)
        sections = []
        skope = self.find_by_user(user)
        sections << skope.sections if !skope.blank?
        return sections.flatten
    end

    def self.load_data
        self.create(utid: 'shahabad', sections: [8])
        self.create(utid: 'arsalehi', sections: [4])
        self.create(utid: 'kananian', sections: [9])
        self.create(utid: 'talizadeh', sections: [6])
        self.create(utid: 'aeinifar', sections: [12])
        self.create(utid: 'myahya', sections: [19])
        self.create(utid: 'jasghari', sections: [1])
        self.create(utid: 'mmassumi', sections: [3])
        self.create(utid: 'sdaghaee', sections: [15])
        self.create(utid: 'gmohamad', sections: [30])
        self.create(utid: 'prostami', sections: [29])
        self.create(utid: 'delshad', sections: [17])
        self.create(utid: 'zendedel', sections: [7])
        self.create(utid: 'mehdinaji', sections: [2])
        self.create(utid: 'e.alidoust', sections: [13])
        self.create(utid: 'hfaraji', sections: [14])
        self.create(utid: 'jpkarimi', sections: [18])
        self.create(utid: 'bikaranlou', sections: [20])
        self.create(utid: 'rehejazi', sections: [24])
        self.create(utid: 'mashaykhi', sections: [26])
        self.create(utid: 'motavalli', sections: [31])
        self.create(utid: 'ryazdan', sections: [28])
        self.create(utid: 'mpeigham', sections: [16])
        self.create(utid: 'akasa', sections: [22])
        self.create(utid: 'adizaji', sections: [17])
        self.create(utid: 'ashtiani', sections: [17])
        self.create(utid: 'm.sharifi', sections: [17])
        self.create(utid: 'attarod', sections: [17])
        self.create(utid: 'aasadi', sections: [17])
        self.create(utid: 'saeed', sections: [8])
        self.create(utid: 'araabi', sections: [8])
        self.create(utid: 'kerachian', sections: [8])
        self.create(utid: 'rshahosseini', sections: [8])
        self.create(utid: 'afnajafi', sections: [8])
        self.create(utid: 'taleizadeh', sections: [8])
        self.create(utid: 'alireza.babaei', sections: [8])
        self.create(utid: 'a_moradzadeh', sections: [8])
        self.create(utid: 'ghorban', sections: [8])
        self.create(utid: 'khashrafi', sections: [22])
        self.create(utid: 'roshandeh', sections: [8])
        self.create(utid: 'hasanzadeh', sections: [8])
        self.create(utid: 'zshafaie', sections: [8])
        self.create(utid: 'fdoulati', sections: [8])
        self.create(utid: 'mortezasoltanee', sections: [10])
        self.create(utid: 'h.dejabad', sections: [10])
        self.create(utid: 'kfouladi', sections: [10])
        self.create(utid: 'eshams', sections: [10])
        self.create(utid: 'a.faraji', sections: [10])
        self.create(utid: 'kananian', sections: [9])
        self.create(utid: 'rnaderloo', sections: [9])
        self.create(utid: 'arefian', sections: [9])
        self.create(utid: 'hassanpar', sections: [9])
        self.create(utid: 'vtavakdi', sections: [9])
        self.create(utid: 'hebrahim', sections: [9])
        self.create(utid: 'y.abdi', sections: [9])
        self.create(utid: 'rokny', sections: [9])
        self.create(utid: 'mjtabesh', sections: [9])
        self.create(utid: 'majid.saidi', sections: [9])
        self.create(utid: 'ashayest', sections: [9])
        self.create(utid: 'marashi', sections: [9])
        self.create(utid: 'abozorg', sections: [9])
        self.create(utid: 'mjtabesh', sections: [9])
        self.create(utid: 'hhoseini', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'ebrahim', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'seyedjafari', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'mirghaed', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'mghazeri', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'zazizi', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'sfdehkordi', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'm.shoaafar', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'msoleyman', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'sharifi', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'shahhoseini', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'ofatemi', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'cto', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'utec.director', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
        self.create(utid: 'h.shafiei', sections: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32])
    end
end
