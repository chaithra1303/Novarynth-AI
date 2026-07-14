# Novarynth AI

Novarynth AI is a research-oriented astronomical analysis platform for galaxy morphology classification. It classifies galaxies as `Spiral`, `Elliptical`, or `Irregular`, explains model attention visually, detects uncertain predictions, and compares custom CNN, EfficientNet, and ResNet model families through a weighted ensemble.

This is intentionally not a basic CNN clone. The project is organized as a complete platform: advanced preprocessing, metadata-aware inference, uncertainty scoring, explainability overlays, model comparison analytics, PDF reporting, Docker support, and a futuristic React observatory dashboard.

## Core Features

- FastAPI backend with modular folders for preprocessing, augmentation, training, explainability, inference, and visualization.
- Hybrid morphology preprocessing: adaptive histogram equalization, Gaussian denoising, contrast stretching, astronomical normalization, faint-object brightness correction, and rare-class synthetic augmentation.
- Deep learning stack: custom CNN, EfficientNet, ResNet, attention layer, checkpoint saving, GPU compatibility, confidence estimation, and weighted model voting.
- Explainable AI: Grad-CAM heatmaps, attention visualization, uncertainty gauge, and misclassification analytics.
- Metadata integration: optional brightness, redshift, size, and spectral properties can influence confidence calibration.
- React + Tailwind dashboard with upload, live prediction, explainability, model comparison, training curves, dataset statistics, and report generation pages.
- Smart PDF classification reports.
- Docker and Docker Compose support.

## Repository Structure

```text
Novarynth/
  backend/
    app/
      augmentation/
      core/
      explainability/
      inference/
      models/
      preprocessing/
      training/
      visualization/
      main.py
      schemas.py
      utils.py
    checkpoints/
    data/
    requirements.txt
    Dockerfile
  frontend/
    src/
      components/
      lib/
      pages/
    package.json
    tailwind.config.js
    Dockerfile
  docs/
    IEEE_ABSTRACT.md
    PPT_CONTENT.md
    RESEARCH_NOTES.md
  docker-compose.yml
```

## Quick Start

### Backend

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --host 127.0.0.1 --port 8010
```

API docs open at `http://127.0.0.1:8010/docs`.

### Frontend

```bash
cd frontend
npm install
npm run dev
```

Dashboard opens at `http://localhost:5173`.

On Windows, you can also double-click:

```text
start_backend.bat
start_frontend.bat
```

### Docker

```bash
docker compose up --build
```

Backend: `http://localhost:8000`  
Frontend: `http://localhost:5173`

## Dataset Setup

Use Galaxy Zoo or Kaggle astronomical morphology datasets. Place images using this structure:

```text
backend/data/raw/
  spiral/
  elliptical/
  irregular/
```

Optional metadata can be stored in:

```text
backend/data/metadata/galaxy_metadata.csv
```

Recommended metadata columns:

```text
image_id,label,brightness,redshift,size_arcsec,spectral_index
```

## Training

First prepare real labeled images. For a dataset already arranged as class folders:

```bash
cd backend
python -m app.training.prepare_dataset --source-dir path/to/galaxy_dataset --output-dir data/raw --balance-to 5000
```

Expected source layout:

```text
path/to/galaxy_dataset/
  spiral/
  elliptical/
  irregular/
```

For a Kaggle/Galaxy Zoo export with a CSV label file:

```bash
python -m app.training.prepare_dataset --source-dir path/to/images --labels-csv path/to/labels.csv --image-column image_id --label-column label --output-dir data/raw --balance-to 5000
```

Train all architectures:

```bash
cd backend
python -m app.training.train --data-dir data/raw --epochs 20 --model all
```

Train a single model:

```bash
python -m app.training.train --data-dir data/raw --model novarynth_cnn
```

Checkpoints are saved in `backend/checkpoints/`.

## API Endpoints

- `GET /health` - service status and device information.
- `POST /api/predict` - upload a galaxy image and optional metadata.
- `POST /api/explain` - returns prediction with Grad-CAM/attention overlay data.
- `GET /api/models/compare` - model comparison metrics.
- `GET /api/dataset/stats` - dataset distribution and preprocessing summary.
- `GET /api/analytics/training-curves` - accuracy/loss curves.
- `POST /api/reports/pdf` - generate a downloadable PDF report.

## Engineering Notes

The backend can run before checkpoints exist. In that case, it uses deterministic image-statistics fallback logits so that the UI and API remain demoable. Once `.pt` checkpoints are saved, the ensemble automatically uses trained weights.

## License

Academic and portfolio use. Verify dataset licenses before publishing trained checkpoints or derived assets.
