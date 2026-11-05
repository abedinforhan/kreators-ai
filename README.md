# Kreators AI

<<<<<<< HEAD
Train your own AI with question-and-answer pairs, then chat with it.

## Setup (one time)

**Windows:** Double-click `setup.bat`
**Mac/Linux:** Run `bash setup.sh`

This installs Python, PyTorch, and downloads the Qwen model. Takes 10-15 min.

## Use

**Windows:** `start.bat`
**Mac/Linux:** `bash start.sh`

Menu:
- [1] Train My AI — trains on your data (1.5-2.5 hours on CPU)
- [2] Test My AI — ask your AI any question
- [3] Exit

## Your data

Edit `data/train.jsonl`. Each line is:
```json
{"question": "Who is Erling Haaland?", "answer": "Erling Haaland is a Norwegian striker who plays for Manchester City."}
```

Add more questions → retrain → ask new questions.

## Try this first

1. Run `[2] Test My AI` BEFORE training — see what the untrained Qwen model guesses.
2. Then run `[1] Train My AI` — wait for it to finish.
3. Run `[2] Test My AI` again — compare how the answers changed.
=======
Teach a real AI your own facts. Then ask it questions and see what it learned!

---

## What you need

- A laptop: **Windows 10/11**, or a **Mac with macOS 12 (Monterey) or newer** (Apple Silicon and Intel both work)
- About **6 GB of free space** and an internet connection for setup
- A Google account (for training your AI)

---

## Step 1: Get the code

1. Download this project as a ZIP from GitHub (green **Code** button → **Download ZIP**)
2. Unzip it to your Desktop
3. Open the folder in VS Code (File → Open Folder)

---

## Step 2: Install it (one time only)

Open a Terminal inside VS Code (**Terminal → New Terminal**), then:

**Windows:** type `.\setup.bat` and press Enter
**Mac:** type `bash setup.sh` and press Enter (it may ask for your computer password once, to install Python)

Setup does everything by itself: installs Python if needed, picks the right AI tools for your computer, downloads the AI model, and checks it all worked. Wait until you see **SETUP COMPLETE!** (10-15 minutes). Grab a snack.

---

## Step 3: Try the untrained AI first

In the Terminal, run:

**Windows:** `.\start.bat`
**Mac:** `bash start.sh`

You'll see a menu:

```
[1] Train My AI
[2] Test My Trained AI
[3] Test Untrained Brain
[4] Exit
```

**Choose [3]** and ask it something like:

> What is Artemis II?

Notice how weird or wrong the answer is. This is the AI **before** you teach it anything.

---

## Step 4: Add your own facts

Open the file `data/train.jsonl`. Each line looks like this:

```json
{"question": "What is Mars?", "answer": "Mars is the fourth planet from the Sun."}
```

Add your own questions and answers, one per line. Save the file.

**Tips:**
- Keep answers short (1-2 sentences)
- Add at least 20-30 examples for good results

---

## Step 5: Train the AI on Google Colab (the fast way)

Training on your laptop would take **many hours**. Instead, we use Google's free super-computer.

1. Go to https://colab.research.google.com
2. Sign in with your Google account
3. Click **File → Upload notebook** and pick `kreators_ai_train.ipynb` from your project folder
4. Click **Runtime → Change runtime type → T4 GPU → Save**
5. Copy your `data/train.jsonl` contents into the training data cell (Step 3 in the notebook)
6. Click each cell's play button ▶ from top to bottom
7. Wait about 30-60 minutes for training to finish
8. The last cell will download 3 files: `adapter_config.json`, `adapter_model.safetensors`, `tokenizer.json`

---

## Step 6: Install your trained AI

On your laptop:

1. In your project folder, make a new folder called **my-ai-trained-brain** (if it doesn't already exist)
2. Move all 3 downloaded files into that folder

Your project should look like this:

```
kreators-ai/
├── my-ai-trained-brain/
│   ├── adapter_config.json
│   ├── adapter_model.safetensors
│   └── tokenizer.json
├── data/
│   └── train.jsonl
├── start.bat
└── ...
```

---

## Step 7: Test your trained AI!

Run `start.bat` again and choose **[2] Test My Trained AI**.

Ask the same question from Step 3:

> What is Artemis II?

Compare the answer to what the untrained AI said. **This is what your data taught it!**

---

## Fun things to try

- Ask the same question in **[2]** and **[3]** to see how much training changed the AI
- Add wrong answers on purpose to see the AI learn wrong facts
- Delete most of your data and retrain to see it get confused
- Try a completely different topic (dinosaurs, video games, your favourite books) and train again

---

## Something not working?

- **"Setup has not been completed"** → run setup first (Step 2)
- **\"pyarrow requires NumPy 2.0 or newer\"** (or any ImportError when training) → this is a leftover install from an older version. Run setup again; it replaces the old one
- **Setup stopped with an error** → run it again once. If it fails again, take a screenshot of the whole Terminal and send it to your teacher
- **Mac says "macOS 12 or newer"** → update macOS in System Settings → Software Update
- **Training too slow?** → use Google Colab (Step 5), not your laptop
- **AI gives weird answers** → add more training examples and train again

>>>>>>> d2aae20 (fixed the issues)
