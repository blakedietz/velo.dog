import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

Main.embed(document.getElementById('root'));

setTimeout(() => {
  let counter = document.querySelector('.timer');
  window.addEventListener('deviceorientation', (e) => {

    counter.style.transform = `rotate(${e.gamma}deg) rotate3d(1,0,0, ${e.beta * -1}deg)`
  });

}, 500);

registerServiceWorker();
