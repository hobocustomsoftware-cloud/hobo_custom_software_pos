# License Key Generator (Standalone)

Django မလိုဘဲ License key ထုတ်ခြင်း။

## Usage

```bash
cd license_generator

# On-Premise (တစ်ခါဝယ် အမြဲသုံး)
python generate_license.py --type on_premise_perpetual

# Hosted (တစ်နှစ်)
python generate_license.py --type hosted_annual --years 1

# များများထုတ်ချင်ရင်
python generate_license.py --type on_premise_perpetual --count 5

# JSON ဖိုင်သို့ သိမ်းခြင်း
python generate_license.py --type on_premise_perpetual --output keys.json

# SQL ထုတ်ခြင်း (Django DB ထဲ ထည့်ရန်)
python generate_license.py --type on_premise_perpetual --sql
```

## JSON မှ Django DB သို့ ထည့်ခြင်း

```bash
# 1. Key ထုတ်ပြီး JSON သိမ်းခြင်း
python generate_license.py --type on_premise_perpetual --output keys.json

# 2. WeldingProject မှ run ပြီး import လုပ်ခြင်း
cd ../WeldingProject
python ../license_generator/import_to_django.py ../license_generator/keys.json
```

## Dependencies

Python 3.7+ လိုပါသည်။ generate_license.py အတွက် ပြင်ပ္ package မလိုပါ။ import_to_django.py အတွက် Django လိုပါသည်။
