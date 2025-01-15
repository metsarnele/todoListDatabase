CREATE TABLE Users (
    user_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Unikaalne kasutaja ID. INT UNSIGNED on valitud, sest see võimaldab suuri positiivseid väärtusi (kuni 4,29 miljardit) ja AUTO_INCREMENT tagab automaatse ID suurendamise.',
    username VARCHAR(50) UNIQUE NOT NULL COMMENT 'Kasutajanimi. VARCHAR(50) on piisav lühikeste ja kordumatute nimede salvestamiseks.',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT 'E-posti aadress. VARCHAR(100) on piisav enamiku e-posti aadresside salvestamiseks.',
    password_hash VARCHAR(255) NOT NULL COMMENT 'Salastatud parool. VARCHAR(255) mahutab kaasaegsete krüpteerimisalgoritmide väljundid.',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Kasutaja loomise kuupäev ja kellaaeg. TIMESTAMP valiti, kuna see on ajavööndiga seotud ja salvestab väärtuse efektiivselt.'
) ENGINE=InnoDB COMMENT='Tabel kasutajate andmete hoidmiseks.';

INSERT INTO Users (username, email, password_hash)
VALUES
('john_doe', 'john@example.com', 'hashed_password_123'),
('jane_smith', 'jane@example.com', 'hashed_password_456');

CREATE TABLE Lists (
    list_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Unikaalne nimekirja ID. INT UNSIGNED sobib suure arvu nimekirjade jaoks ja AUTO_INCREMENT tagab ID automaatse suurenemise.',
    user_id INT UNSIGNED NOT NULL COMMENT 'Viide kasutajale, kellele nimekiri kuulub. INT UNSIGNED vastab kasutajate tabeli user_id-le.',
    list_name VARCHAR(100) NOT NULL COMMENT 'Nimekirja nimi. VARCHAR(100) võimaldab piisavat pikkust nimede salvestamiseks.',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Nimekirja loomise kuupäev ja kellaaeg.',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Viimane muutmisaeg. TIMESTAMP koos ON UPDATE võimaldab automaatset ajatempli värskendamist.',
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
) ENGINE=InnoDB COMMENT='Tabel to-do nimekirjade andmete hoidmiseks.';

INSERT INTO Lists (user_id, list_name)
VALUES
(1, 'Daily Tasks'),
(1, 'Work Projects'),
(2, 'Shopping List');

CREATE TABLE Tasks (
    task_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Unikaalne ülesande ID. INT UNSIGNED on piisav väga suure arvu ülesannete jaoks ja AUTO_INCREMENT tagab automaatse ID suurendamise.',
    list_id INT UNSIGNED NOT NULL COMMENT 'Viide nimekirjale, mille osa ülesanne on. INT UNSIGNED vastab nimekirjade tabeli list_id-le.',
    task_name VARCHAR(255) NOT NULL COMMENT 'Ülesande nimi. VARCHAR(255) on valitud, sest ülesannete kirjeldused võivad olla pikemad.',
    is_completed BOOLEAN DEFAULT FALSE COMMENT 'Staatuse jälgimine. BOOLEAN (alias TINYINT) võimaldab väärtuseid TRUE (1) või FALSE (0).',
    due_date TIMESTAMP DEFAULT NULL COMMENT 'Ülesande tähtaeg. TIMESTAMP on ajavööndiga seotud ja efektiivsem lühiajaliste ajatempli nõuete jaoks.',
    FOREIGN KEY (list_id) REFERENCES Lists(list_id)
) ENGINE=InnoDB COMMENT='Tabel ülesannete andmete hoidmiseks.';

INSERT INTO Tasks (list_id, task_name, is_completed, due_date)
VALUES
(1, 'Buy groceries', FALSE, '2025-01-15 18:00:00'),
(1, 'Reply to emails', TRUE, NULL),
(2, 'Prepare presentation', FALSE, '2025-01-20 09:00:00');

CREATE TABLE Tags (
    tag_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Unikaalne sildi ID. INT UNSIGNED sobib suure hulga siltide salvestamiseks ja AUTO_INCREMENT tagab ID automaatse suurenemise.',
    user_id INT UNSIGNED NOT NULL COMMENT 'Viide kasutajale, kes sildi lõi. INT UNSIGNED vastab kasutajate tabeli user_id-le.',
    tag_name VARCHAR(50) UNIQUE NOT NULL COMMENT 'Sildi nimi. VARCHAR(50) on piisav lühikeste ja kordumatute siltide salvestamiseks.',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Sildi loomise kuupäev ja kellaaeg.',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Viimane muutmisaeg. TIMESTAMP koos ON UPDATE võimaldab automaatset ajatempli värskendamist.',
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
) ENGINE=InnoDB COMMENT='Tabel siltide andmete hoidmiseks.';

INSERT INTO Tags (user_id, tag_name)
VALUES
(1, 'Urgent'),
(1, 'Personal'),
(2, 'Work');

CREATE TABLE Task_Tags (
    task_tag_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Unikaalne ID iga ülesande ja sildi seose jaoks. INT UNSIGNED sobib suure hulga seoste salvestamiseks.',
    task_id INT UNSIGNED NOT NULL COMMENT 'Viide ülesandele. INT UNSIGNED vastab ülesannete tabeli task_id-le.',
    tag_id INT UNSIGNED NOT NULL COMMENT 'Viide sildile. INT UNSIGNED vastab siltide tabeli tag_id-le.',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Seose loomise kuupäev ja kellaaeg.',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Viimane muutmisaeg. TIMESTAMP koos ON UPDATE võimaldab automaatset ajatempli värskendamist.',
    UNIQUE (task_id, tag_id) COMMENT 'Kombineeritud unikaalsus, et vältida sama ülesande ja sildi korduvaid seoseid.',
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id)
) ENGINE=InnoDB COMMENT='Tabel ülesannete ja siltide vaheliste seoste hoidmiseks.';

INSERT INTO Task_Tags (task_id, tag_id)
VALUES
(1, 1),
(1, 2),
(3, 3);
