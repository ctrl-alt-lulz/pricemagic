import ReactOnRails from 'react-on-rails';
import HelloWorld from '../components/HelloWorld';
import CategoryContainer from '../components/CategoryContainer';
import ProductCategoryRow from '../components/ProductCategoryRow';

// This is how react_on_rails can see the HelloWorld in the browser.
ReactOnRails.register({
    HelloWorld,
    CategoryContainer,
    ProductCategoryRow
});
