import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="authenticate"
export default class extends Controller {
  focus({ target: { parentElement } }) {
    const targetTokenList = parentElement.classList;
    targetTokenList.remove('border-b');
    targetTokenList.add('border-authLink', 'border-b-2');
  }

  blur({ target: { parentElement } }) {
    const targetTokenList = parentElement.classList;
    targetTokenList.add('border-b');
    targetTokenList.remove('border-authLink', 'border-b-2');
  }

  navigate({
    target: {
      dataset: { currentPage, targetPage },
    },
  }) {
    document.querySelector(`.authenticate .${targetPage}`).classList.replace('hidden', 'flex');
    document.querySelector(`.authenticate .${currentPage}`).classList.replace('flex', 'hidden');
  }
}
