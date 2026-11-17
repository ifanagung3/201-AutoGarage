import argparse
import json
import os
from datetime import datetime,timezone
from playwright.sync_api import sync_playwright,expect
from bootstrap import ROOT,read_env

def main(mode):
    env=read_env();out=ROOT/'evidence';out.mkdir(exist_ok=True)
    with sync_playwright() as p:
        browser=p.chromium.launch(args=['--no-proxy-server'])
        context=browser.new_context(viewport={'width':1440,'height':1080},locale='id-ID')
        page=context.new_page()
        page.goto('http://api.lokal:8080/demo',wait_until='networkidle')
        page.locator('#login').click()
        expect(page.locator('#username')).to_be_visible(timeout=30000)
        page.screenshot(path=str(out/f'{mode}-sso-login.png'),full_page=True)
        page.locator('#username').fill('ifan')
        page.locator('#password').fill(env['DEMO_PASSWORD'])
        page.locator('#kc-login').click()
        expect(page.locator('#auth-badge')).to_be_visible(timeout=30000)
        expect(page.locator('#account')).to_have_text('Ifan Agung Arisadi')
        page.screenshot(path=str(out/f'{mode}-sso-success.png'),full_page=True)
        page.locator('#predict').click()
        expect(page.locator('#saved')).to_contain_text('Tersimpan di primary',timeout=30000)
        expect(page.locator('#source')).to_contain_text('Sumber pembacaan: replica',timeout=15000)
        expect(page.locator('#history tr').first).to_be_visible(timeout=15000)
        page.screenshot(path=str(out/f'{mode}-inference-history.png'),full_page=True)
        proof={'environment':mode,'time':datetime.now(timezone.utc).isoformat(),
               'flow':'Keycloak authorization code + PKCE S256; public web client',
               'name':page.locator('#account').inner_text(),'cost':page.locator('#cost').inner_text(),
               'duration':page.locator('#duration').inner_text(),'saved':page.locator('#saved').inner_text(),
               'read_source':page.locator('#source').inner_text(),'model':page.locator('#model').inner_text()}
        (out/f'{mode}-browser.json').write_text(json.dumps(proof,indent=2,ensure_ascii=False))
        print(json.dumps(proof,ensure_ascii=False))
        browser.close()

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('mode',choices=['compose','kubernetes'])
    main(parser.parse_args().mode)
