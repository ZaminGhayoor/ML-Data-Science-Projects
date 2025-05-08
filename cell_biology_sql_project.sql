
-- SQL Project: Cell Biology - Cell Types and Organelle Interactions

-- STEP 1: SCHEMA DEFINITION

CREATE TABLE CellType (
    cell_type_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    organism TEXT,
    tissue TEXT
);

CREATE TABLE Organelle (
    organelle_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    function TEXT,
    category TEXT
);

CREATE TABLE CellOrganelleProfile (
    cell_type_id INTEGER,
    organelle_id INTEGER,
    count INTEGER,
    volume_fraction REAL,
    presence_flag BOOLEAN,
    PRIMARY KEY (cell_type_id, organelle_id),
    FOREIGN KEY (cell_type_id) REFERENCES CellType(cell_type_id),
    FOREIGN KEY (organelle_id) REFERENCES Organelle(organelle_id)
);

CREATE TABLE OrganelleInteraction (
    interaction_id INTEGER PRIMARY KEY,
    organelle1_id INTEGER,
    organelle2_id INTEGER,
    cell_type_id INTEGER,
    interaction_type TEXT,
    detail TEXT,
    unique_to_cell BOOLEAN,
    FOREIGN KEY (organelle1_id) REFERENCES Organelle(organelle_id),
    FOREIGN KEY (organelle2_id) REFERENCES Organelle(organelle_id),
    FOREIGN KEY (cell_type_id) REFERENCES CellType(cell_type_id)
);

-- STEP 2: SAMPLE DATA

INSERT INTO CellType VALUES
(1, 'Hepatocyte', 'Human', 'Liver'),
(2, 'Neuron', 'Human', 'Brain'),
(3, 'Red Blood Cell', 'Human', 'Blood'),
(4, 'Leaf Mesophyll Cell', 'Plant', 'Leaf'),
(5, 'Sperm Cell', 'Human', 'Reproductive');

INSERT INTO Organelle VALUES
(1, 'Nucleus', 'DNA storage and transcription', 'Information'),
(2, 'Mitochondrion', 'ATP production', 'Energy'),
(3, 'Chloroplast', 'Photosynthesis', 'Energy'),
(4, 'Golgi Apparatus', 'Protein modification and transport', 'Endomembrane'),
(5, 'Acrosome', 'Penetration of egg', 'Reproductive');

INSERT INTO CellOrganelleProfile VALUES
(1, 1, 1, 0.10, TRUE),
(1, 2, 2000, 0.20, TRUE),
(1, 4, 50, 0.05, TRUE),
(2, 1, 1, 0.15, TRUE),
(2, 2, 1000, 0.18, TRUE),
(2, 4, 60, 0.06, TRUE),
(3, 1, 0, 0.00, FALSE),
(3, 2, 0, 0.00, FALSE),
(4, 1, 1, 0.12, TRUE),
(4, 2, 500, 0.10, TRUE),
(4, 3, 100, 0.25, TRUE),
(5, 1, 1, 0.08, TRUE),
(5, 2, 75, 0.07, TRUE),
(5, 5, 1, 0.03, TRUE);

INSERT INTO OrganelleInteraction VALUES
(1, 1, 2, 1, 'Signaling', 'Nucleus-Mitochondria gene regulation', FALSE),
(2, 2, 3, 4, 'Metabolic', 'Photorespiration coupling', TRUE),
(3, 2, 4, 1, 'Transport', 'Golgi packs mitochondrial proteins', FALSE),
(4, 1, 5, 5, 'Developmental', 'Acrosome forms near nucleus', TRUE);

-- STEP 3: SAMPLE QUERIES

-- 1. List all cell types with mitochondria and their counts
-- SELECT C.name AS cell_type, P.count AS mitochondria_count
-- FROM CellOrganelleProfile P
-- JOIN CellType C ON P.cell_type_id = C.cell_type_id
-- JOIN Organelle O ON P.organelle_id = O.organelle_id
-- WHERE O.name = 'Mitochondrion' AND P.presence_flag = TRUE
-- ORDER BY P.count DESC;

-- 2. Show organelles not present in red blood cells
-- SELECT O.name
-- FROM CellOrganelleProfile P
-- JOIN Organelle O ON P.organelle_id = O.organelle_id
-- WHERE P.cell_type_id = 3 AND P.presence_flag = FALSE;

-- 3. Unique organelle interactions
-- SELECT C.name AS cell_type, O1.name AS organelle1, O2.name AS organelle2
-- FROM OrganelleInteraction I
-- JOIN Organelle O1 ON I.organelle1_id = O1.organelle_id
-- JOIN Organelle O2 ON I.organelle2_id = O2.organelle_id
-- JOIN CellType C ON I.cell_type_id = C.cell_type_id
-- WHERE I.unique_to_cell = TRUE;

-- 4. Find cell types with chloroplasts
-- SELECT C.name
-- FROM CellOrganelleProfile P
-- JOIN CellType C ON P.cell_type_id = C.cell_type_id
-- JOIN Organelle O ON P.organelle_id = O.organelle_id
-- WHERE O.name = 'Chloroplast' AND P.presence_flag = TRUE;

-- 5. Compare mitochondria count between hepatocytes and neurons
-- SELECT C.name AS cell_type, P.count AS mitochondria_count
-- FROM CellOrganelleProfile P
-- JOIN CellType C ON P.cell_type_id = C.cell_type_id
-- JOIN Organelle O ON P.organelle_id = O.organelle_id
-- WHERE C.name IN ('Hepatocyte', 'Neuron') AND O.name = 'Mitochondrion';
