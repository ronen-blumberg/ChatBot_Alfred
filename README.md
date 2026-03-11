# Chatbot Alfred

A supportive companion chatbot for people struggling with mental health, trauma, and abuse — built with FreeBASIC and the Window9 GUI library.

> **IMPORTANT DISCLAIMER:** Chatbot Alfred is **NOT** a replacement for professional mental health help. If you are in crisis, please call **988** (US Suicide & Crisis Lifeline), **116 123** (UK Samaritans), or visit [findahelpline.com](https://findahelpline.com) for international resources. In an emergency, call your local emergency number (911 in the US).

---

## About

Chatbot Alfred is an open-source desktop chatbot designed to be a compassionate listening companion for people dealing with mental illness, trauma, and abuse. It uses an ELIZA-style keyword matching algorithm to provide warm, empathetic responses from a curated database focused on mental health support.

Alfred is not a therapist, counselor, or AI assistant. He is a simple chatbot that offers a safe, private, non-judgmental space to express your feelings. Alfred will listen, validate your pain, and gently encourage you to seek professional help when needed.

**Who is Alfred for?**

- People who need someone to talk to when no one else is available
- Trauma and abuse survivors who want to practice opening up
- Anyone struggling with mental health who could use a compassionate ear
- People who find it easier to talk to a chatbot before talking to a person

**What Alfred is NOT:**

- Not a replacement for therapy, medication, or professional help
- Not an AI with real understanding or memory
- Not suitable for crisis intervention (though he provides crisis hotline numbers)

---

## Features

- **ELIZA-Style Conversation Engine** — Keyword matching algorithm with word-swap reflection for natural conversational flow
- **Mental Health Focused Database** — 46 organized sections covering trauma, abuse, depression, anxiety, PTSD, grief, self-harm, addiction, LGBTQ+ support, neurodivergence, chronic illness, body image, burnout, eating disorders, panic attacks, OCD, bipolar, schizophrenia, codependency, generational trauma, phobias, seasonal depression, survivor's guilt, gender dysphoria, and more
- **Text-to-Speech** — Windows SAPI5 TTS support so Alfred speaks his responses aloud (Linux espeak-ng support in code)
- **Crisis Detection** — Automatically provides crisis hotline numbers (988, Samaritans, findahelpline.com) when suicidal or self-harm keywords are detected
- **Encrypted Database** — Database is encrypted with a substitution cipher to prevent casual tampering
- **Resizable GUI** — Window9 library with scalable interface, font caching, and keyboard shortcuts
- **Grounding Techniques** — Built-in grounding exercises (5-4-3-2-1, breathing, cold water) for when users are in distress
- **Privacy First** — No data is stored, saved, or transmitted. All conversations are completely private

---

## Screenshots

[![Chatbot Alfred Screenshot](https://i.postimg.cc/FKqbHgmD/zylwm-msk-2026-03-11-163018.png)](https://postimg.cc/1gGVWF8q)

---

## System Requirements

- **Operating System:** Windows 7, 10, or 11 (32-bit or 64-bit)
- **Compiler:** [FreeBASIC 1.10.1](https://www.freebasic.net/) (32-bit, for building from source)
- **GUI Library:** Window9 (included with FreeBASIC)
- **TTS Engine:** Windows SAPI5 (included with Windows)
- **Dependencies:** DispHelper library for COM/SAPI5 integration (included)

---

## Building from Source

### Prerequisites

1. Download and install [FreeBASIC 1.10.1](https://www.freebasic.net/wiki/CompilerInstalling) (32-bit version)
2. Ensure the Window9 library is available (ships with FreeBASIC)

### Compile the Chatbot

```bash
cd path/to/fb_chatbot_alfred
fbc32.exe fb_chatbot_alfred_gui.bas
```

This compiles the main GUI file, which automatically includes the core engine (`fb_chatbot_alfred.bas`) and TTS module (`TTS.bas`) via `#INCLUDE` directives.

### Compile the Database Encryption Tool

```bash
cd database
fbc32.exe -s console fb_encrypt_database.bas
```

### Run

```bash
fb_chatbot_alfred_gui.exe
```

**Note:** The executable must be run from the project directory so it can find the `database/` folder.

---

## Usage Guide

1. **Launch** the application — Alfred greets you with a time-appropriate message
2. **Type** your message in the bottom text area
3. **Press Enter** or click the **Talk** button to send your message
4. Alfred's response appears in the top area and is spoken aloud via TTS
5. Click the **About** button to view the instructions and disclaimer

### Tips for Talking with Alfred

- Speak naturally — Alfred looks for keywords in what you say
- Tell him how you're feeling: "I feel sad", "I'm anxious", "I'm overwhelmed"
- Talk about specific issues: "I was abused", "I have PTSD", "I'm addicted"
- Ask for grounding: "help me calm down", "grounding technique"
- If you need help: type `-help` to open the instructions file
- Alfred works best with short, focused statements rather than long paragraphs

---

## How It Works

### The ELIZA Algorithm

Chatbot Alfred uses a keyword matching algorithm inspired by Joseph Weizenbaum's ELIZA (1966), one of the earliest chatbot programs. Here's how it works:

1. **Input Processing** — Your message is converted to lowercase, and punctuation is isolated from words
2. **Keyword Matching** — Alfred searches through his database for keywords that appear in your message (e.g., "I feel sad" matches the keyword "sad")
3. **Response Selection** — A random response is selected from the replies associated with the matched keyword group
4. **Word Swapping** — For reflective responses (marked with `*`), Alfred swaps pronouns in your input to create a natural echo (e.g., "I am" becomes "you are", "my" becomes "your")
5. **Default Responses** — If no keywords match, Alfred selects from 60 warm, empathetic default responses

### Word Swap (Reflection)

The word swap mechanism is key to ELIZA-style conversation. When a reply ends with `*`, Alfred appends a transformed version of your input:

- You say: "I am feeling lost and my life is hard"
- Keyword "feeling lost" is matched
- Reply template: "tell me more about why you feel*"
- Word swap transforms: "I am" → "you are", "my" → "your"
- Final response: "tell me more about why you feel lost and your life is hard"

---

## Database Format

The database (`database/database.txt`) uses a simple line-based format with prefix tags:

| Prefix   | Description                                         | Example                    |
| -------- | --------------------------------------------------- | -------------------------- |
| `k:`     | Keyword — matched against user input                | `k:depression`             |
| `r:`     | Reply — response for the preceding keyword group    | `r:i hear you dear one...` |
| `r:...*` | Reply with tail-append — appends swapped user input | `r:tell me more about*`    |
| `s:`     | Word swap pair — format `s:input>output`            | `s:I>you`                  |
| `d:`     | Default response — used when no keyword matches     | `d:please go on...`        |
| `c1:`    | Command — triggers the instruction file             | `c1:-help`                 |

### Database Rules

- Keywords (`k:`) must come before their replies (`r:`)
- Multiple `k:` lines can share the same `r:` replies (they form a group)
- A new `k:` line after `r:` lines starts a new keyword group
- Lines without a recognized prefix are ignored (can be used for comments/headers)
- The database only encrypts letters A-Z and a-z; numbers and punctuation pass through unchanged

---

## Database Topics (46 Sections)

1. **Word Swaps** — 47 pronoun reflection pairs for ELIZA-style mirroring (including multi-word swaps)
2. **Greetings & Farewells** — Hello, goodbye, how are you
3. **Crisis & Safety** — Suicide, self-harm, safety planning (provides hotline numbers; includes social media euphemisms like "unalive")
4. **Abuse & Trauma** — Physical, emotional, sexual, childhood abuse, narcissistic abuse, gaslighting, domestic violence, cyberbullying, stalking, fight/flight/freeze/fawn psychoeducation
5. **Mental Health Conditions** — Depression, anxiety, PTSD, C-PTSD, BPD, dissociation, flashbacks, hypervigilance, cognitive distortions
6. **Emotions** — Sadness, crying, numbness, grief, guilt, overwhelm, hopelessness, frustration, jealousy, confusion, dread, irritability, apathy, resentment
7. **Self-Esteem & Self-Worth** — Worthlessness, self-hatred, feeling unlovable, feeling like a burden
8. **Loneliness & Isolation** — Being alone, feeling invisible, needing connection, being ghosted
9. **Relationships & Family** — Family conflict, breakups, trust issues, toxic friendships, estrangement
10. **Recovery, Healing & Hope** — Progress, grounding techniques, self-care, boundaries, therapy types, DBT skills
11. **About Alfred** — What Alfred is, his limitations, honest self-awareness
12. **General Topics** — Life struggles, meaning of life, physical pain, sleep, finances, work stress, school, retirement
13. **Substance Abuse & Addiction** — Addiction, alcoholism, sobriety, relapse, gambling, recovery milestones, supporting loved ones
14. **LGBTQ+ Identity & Support** — Coming out, gender identity, acceptance, discrimination, family rejection
15. **ADHD & Neurodivergence** — ADHD, autism, executive dysfunction, masking, sensory overload
16. **Postpartum & Parenting** — Postpartum depression, parenting guilt, single parenting
17. **Perfectionism** — Impossible standards, self-criticism, imposter syndrome, fear of failure
18. **Gratitude & Positive** — Thankfulness, appreciation
19. **Arguing & Hostile Input** — Insults, frustration (handled with grace)
20. **Chronic Illness & Chronic Pain** — Chronic pain, disability, invisible illness, medical gaslighting
21. **Body Image & Body Dysmorphia** — Body image struggles, weight stigma, aging body, aging/youth
22. **Grief Anniversaries & Triggers** — Death anniversaries, anticipatory grief, complicated grief
23. **Burnout** — Exhaustion, compassion fatigue, decision fatigue, brain fog
24. **Self-Harm & Recovery** — Self-harm, cutting, recovery, scars, coping strategies
25. **Anger Management** — Rage, losing temper, anger at self, healthy expression
26. **Eating Disorders** — Anorexia, bulimia, binge eating, emotional eating, body weight struggles
27. **Panic Attacks** — Panic attacks, agoraphobia, breathing techniques, grounding
28. **OCD** — Obsessive thoughts, compulsive behaviors, intrusive thoughts, contamination fears
29. **Bipolar Disorder** — Mood swings, manic episodes, depressive episodes, mood cycling
30. **Schizophrenia & Psychosis** — Hallucinations, delusions, paranoia, hearing voices, supporting loved ones with psychosis
31. **Shame & Embarrassment** — Shame, humiliation, disgrace, public embarrassment, self-acceptance
32. **Sleep & Insomnia** — Nightmares, night terrors, racing thoughts at night, insomnia, trauma-related nightmares
33. **Mindfulness & Relaxation** — Breathing exercises, grounding, meditation, calming techniques, progressive muscle relaxation, body scan
34. **Workplace Mental Health** — Toxic workplace, bullying, harassment, work-life balance
35. **Caregiver Stress** — Caregiver burnout, caring for sick loved ones, dementia care, hospice support
36. **Miscarriage & Reproductive Loss** — Pregnancy loss, stillborn, infertility, IVF struggles, partner grief
37. **Spiritual & Religious Struggles** — Faith crisis, anger at God, questioning beliefs, religious trauma
38. **Identity & Life Purpose** — Identity crisis, existential questions, midlife/quarter-life crisis, career purpose
39. **Codependency & Attachment** — People pleasing, unhealthy attachment, enmeshment, boundaries, attachment styles
40. **Generational & Cultural Trauma** — Inherited trauma, family patterns, breaking cycles, cultural-specific trauma
41. **Phobias** — Specific phobias, agoraphobia, social phobia, fear avoidance, exposure therapy
42. **Seasonal Depression (SAD)** — Winter depression, seasonal mood changes, light therapy, seasonal coping
43. **Survivor's Guilt** — Survivor guilt, guilt after loss, why did I survive, guilt after trauma
44. **Gender Dysphoria** — Gender dysphoria, gender identity, transitioning, body disconnect, chosen name/pronouns
45. **Default Responses** — 60 warm fallback responses
46. **Commands** — Help commands

---

## Crisis Resources

If you or someone you know is in crisis:

| Country            | Hotline                   | Phone/Text                                     |
| ------------------ | ------------------------- | ---------------------------------------------- |
| **United States**  | Suicide & Crisis Lifeline | Call or text **988**                           |
| **United Kingdom** | Samaritans                | Call **116 123**                               |
| **Canada**         | Suicide Crisis Helpline   | Call or text **988**                           |
| **International**  | Find A Helpline           | [findahelpline.com](https://findahelpline.com) |
| **Emergency**      | Local emergency services  | **911** (US) / **999** (UK) / **112** (EU)     |

---

## Modifying the Database

### Adding New Keywords and Replies

1. Open `database/database.txt` in a text editor

2. Add your keywords and replies following the format:
   
   ```
   k:your keyword
   k:another keyword
   
   r:your response here
   r:another response with tail reflection*
   ```

3. Keep responses warm, empathetic, and in Alfred's voice (lowercase; vary terms of address: "dear one", "dear friend", "dear heart", or no term)

4. Aim for at least 4 replies per keyword group to avoid repetition

### Re-encrypting the Database

After modifying `database.txt`, you must re-encrypt it:

```bash
cd database
fbc32.exe -s console fb_encrypt_database.bas
fb_encrypt_database.exe
```

This generates a new `database-encrypted.txt` that the chatbot loads at runtime.

---

## Changelog

### v0.6 (Current)

- **Safety Fix:** Removed 4 dangerous word swaps (`he→I`, `she→I`, `his→my`, `her→my`) that reversed abuse disclosures (e.g., "he hurt me" became "I hurt you")
- **Safety Fix:** Added 15 missing crisis keywords including social media euphemisms (`unalive`, `unaliving`), common misspellings (`suicde`, `kill myslef`), and additional crisis phrases (`want to disappear`, `wish I was never born`, `can't go on`)
- **Safety Fix:** Added safety planning group with keywords (`safety plan`, `warning signs`, `reasons to live`) and 4 responses
- **Structural Fix:** Resolved 40 duplicate keywords across sections that caused mixed/incoherent responses — each keyword now maps to exactly one specialized section
- **Structural Fix:** Narrowed overly broad keywords (`clean`→`getting clean`/`staying clean`, `pain`→`in pain`/`physical pain`, `checking`→`keep checking`/`can't stop checking`, `counting`→`keep counting`/`can't stop counting`)
- **Word Swaps:** Added 18 multi-word swap pairs (`i can't`→`you can't`, `i don't`→`you don't`, etc.) for better reflective responses — 47 total swaps
- **Database — Content Expansion:** Added 4 new topic sections: Phobias, Seasonal Depression (SAD), Survivor's Guilt, Gender Dysphoria — 46 sections total
- **Database:** Added 5 new emotional state keyword groups to Emotions section (frustration, jealousy, confusion/dread, irritability/apathy, resentment) with dedicated replies
- **Database:** Expanded 11 thin sections (30-40) with additional keyword sub-groups (supporting loved ones, public shame, religious trauma, career purpose, attachment styles, cultural trauma, dementia/hospice care, partner grief, progressive muscle relaxation)
- **Database:** Added modern/slang keywords (`spiraling`, `doom scrolling`, `ghosted`, `cyberbullying`, `mental breakdown`, `i'm a burden`)
- **Database:** Added common misspelling keywords for depression, anxiety, trauma, loneliness, and worthlessness
- **Database:** Added estrangement, school, and retirement keyword groups to existing sections
- **Database — Therapeutic Enrichment:** Added DBT skills group (TIPP, opposite action, radical acceptance, wise mind), fight/flight/freeze/fawn psychoeducation, cognitive distortions group, expanded grounding exercises and self-care replies
- **Database — Quality:** Expanded tail-append `*` replies from 5 to 28 for more natural reflective responses across sections
- **Database — Quality:** Reduced repetitive "dear one" usage from 108 to 60, varying with "dear friend" (12) and "dear heart" (3)
- **Database — Quality:** Varied 15 repetitive `*Alfred offers comfort...` action lines with diverse emotional alternatives
- **Database — Quality:** Fixed 3 tone-deaf replies ("you poor thing", dismissive "growing up" response, mismatched comfort line)
- **Database:** Added 8 new default responses (52→60 total) with body-awareness, permission-giving, curiosity, and strength-acknowledging prompts
- **Stats:** 1,076 keywords, 765 replies, 60 defaults, 47 swaps, 28 tail-append replies across 46 sections

### v0.5

- **Dead Code Removal:** Removed unused `InsertStr`, `Replace`, `ReplaceAll` functions from GUI (never called)
- **Dead Code Removal:** Removed unused `TTSvoice` variable from GUI (voice set by `TTS.VoiceByID(0)` instead)
- **Dead Code Removal:** Cleaned up TTS.bas: removed unused variables (`LENT`, `OLD`), removed 6 commented-out debug lines
- **Dead Code Removal:** Removed dead trailing comment in engine `loadArrays()` function
- **Dead Code Removal:** Removed commented-out decryption line from encryption tool
- **Robustness:** Added database load validation after `LoadArrays()` — displays error and exits if database fails to load
- **Bug Fix:** Fixed typo in instruction.txt ("SOME WHAT" → "SOMEWHAT")
- **Database — Major Expansion:** Expanded from 25 to 42 sections with comprehensive mental health coverage
- **Database:** Expanded 9 underdeveloped sections (Substance Abuse, LGBTQ+, ADHD, Postpartum, Perfectionism, Chronic Illness, Body Image, Grief, Burnout) with 2-3 additional keyword sub-groups each
- **Database:** Added 17 new topic sections: Self-Harm & Recovery, Anger Management, Eating Disorders, Panic Attacks, OCD, Bipolar Disorder, Schizophrenia & Psychosis, Shame & Embarrassment, Sleep & Insomnia, Mindfulness & Relaxation, Workplace Mental Health, Caregiver Stress, Miscarriage & Reproductive Loss, Spiritual & Religious Struggles, Identity & Life Purpose, Codependency & Attachment, Generational & Cultural Trauma
- **Database:** Replaced all 13 remaining bare `*Alfred offers comfort` lines with unique varied responses
- **Database:** Added 17 new default responses (35 → 52 total) with more therapeutic prompts
- **Database:** Added 5 new word swap pairs (`we're`/`we've`/`ours`/`they're`/`we'll`) — 33 total
- **Documentation:** Updated README.md with v0.5 changelog and expanded topic list (42 sections)

### v0.4

- **Dead Code Removal:** Removed all leftover GPT-related code (`isApi` variable, `printMessageUsage()` sub)
- **Dead Code Removal:** Removed all commented-out dead code from GUI and engine files
- **Dead Code Removal:** Removed unused `inpt_swap()` function (duplicate of inline word-swap logic)
- **Dead Code Removal:** Removed unused `kFlag` variable from `userQuestion()`
- **Code Quality:** Renamed `Replys` typo to `Replies` in `ArraySet` type and all usages
- **Code Quality:** Fixed comment typos (`isolatePuntuation` → `isolatePunctuation`, `Speakinm` → `Speaking`, `avaliable` → `available`)
- **Code Quality:** Added `CONST ALFRED_VERSION` for centralized version management
- **Code Quality:** Added function docstring comments to all functions in the core engine
- **Robustness:** All file paths now use `EXEPATH` for reliable execution from any working directory
- **Database:** Added 4 new topic sections: Chronic Illness/Pain, Body Image/Dysmorphia, Grief Anniversaries, Burnout
- **Database:** Added 4 new word swap pairs (`he`/`she`/`his`/`her`) for better pronoun reflection
- **Database:** Replaced 15 repetitive `*Alfred offers comfort` responses with varied comfort alternatives
- **Database:** Expanded 15 keyword groups to minimum 4 replies each
- **Documentation:** Updated README.md with v0.4 changelog and expanded topic list (25 sections)

### v0.3

- **Code Quality:** Renamed misspelled `deafult` variable to `defaultReplies`
- **Error Handling:** Added file-open error checking in `loadArrays()` with database validation
- **Input Validation:** Empty and excessively long inputs are now handled gracefully
- **Threading Fix:** Added `TTS.Stop()` before `THREADWAIT` to prevent GUI freeze on rapid input
- **Performance:** Removed redundant `LCASE()` calls in keyword matching and word swapping
- **Font Leak Fix:** Added font caching in `resize_second_form` (matching `size_change` fix from v0.2)
- **Dead Code Cleanup:** Removed commented-out learning mode, unused variables, and old case entries
- **Database:** Added 7 new word swap pairs for better pronoun reflection
- **Database:** Added 5 new topic sections: Substance Abuse/Addiction, LGBTQ+ Identity, ADHD/Neurodivergence, Postpartum Depression, Perfectionism
- **Database:** Added international crisis lines (UK Samaritans 116 123, findahelpline.com)
- **Database:** Expanded 9 thin reply groups to minimum 4 responses each
- **Database:** Added anger management coping techniques
- **Documentation:** Added comprehensive README.md

### v0.2

- Complete database rewrite with 16 organized mental health sections
- Fixed 9 code bugs:
  - Fixed `LEN(cint(punctuation))` crash in `joinPunctuation`
  - Fixed off-by-one errors in default and reply random selection
  - Merged duplicate `CASE EventGadget` blocks (second was unreachable)
  - Removed dead code (`isCounterReplies`, `ReplyCounter`, `isReplay`)
  - Added font handle caching in `size_change` to prevent memory leak
  - Removed erroneous `CLS` from `txtfile()` function
- Expanded default responses from 22 to 35
- Added encrypted database system

### v0.1

- Initial release
- Basic ELIZA-style chatbot with Window9 GUI
- Text-to-speech support

---

## Project Structure

```
fb_chatbot_alfred/
  fb_chatbot_alfred_gui.bas    # Main GUI application (Window9 event loop, TTS)
  fb_chatbot_alfred.bas        # Core ELIZA engine (keyword matching, word swap)
  TTS.bas                      # Windows SAPI5 text-to-speech wrapper
  database/
    database.txt               # Plain-text keyword/reply database (source)
    database-encrypted.txt     # Encrypted database (loaded at runtime)
    fb_encrypt_database.bas    # Encryption/decryption tool
    instruction.txt            # User-facing disclaimer and instructions
    README.txt                 # Database format notes
```

---

## License

This project is licensed under the **GNU General Public License v3.0** (GPL-3.0).

You are free to use, modify, and distribute this software under the terms of the GPL. See [LICENSE](LICENSE) for details.

---

## Credits & Contact

- **Developer:** ron77 ([ron77@email.com](mailto:ron77@email.com))
- **Built with:** [FreeBASIC](https://www.freebasic.net/) and the Window9 GUI library
- **TTS Engine:** Windows SAPI5 via the [DispHelper](http://disphelper.sourceforge.net/) COM library
- **Inspired by:** Joseph Weizenbaum's [ELIZA](https://en.wikipedia.org/wiki/ELIZA) (1966) — one of the first chatbot programs

---

*May we all find peace to live our life without suffering. Amen.*
