import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import {Page, Card, Select, Button, TextField, Stack,
Thumbnail, ResourceList, Pagination, Layout} from '@shopify/polaris';

// onChange={this.searchProducts('term')

class SearchTerms extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      term: '',
      collection: null,
    };
    this.handleChange = this.handleChange.bind(this);
  }
  handleChange(event) {
    this.setState({term: event});
    this.searchProducts()
  }
  
  //() => this.setState({term: 'term'})
  render() {
    function CollectionTitles(collection) {
      return collection.title
    }
    return (
      <Card.Section>
        <Stack>
          <TextField 
            value={this.state.term}
            label="Keyword Search"
            placeholder="Enter Term"
            onChange={this.handleChange}
          />
          <Select
            value= {this.state.collection}
            label="Collection"
            options={ this.props.collections.map(CollectionTitles) }
            placeholder="Select"
            //onChange={this.valueUpdater('collection')}
            //onChange={this.searchProducts('collection')}
          />
        </Stack>
      </Card.Section>
    );
  }
  valueUpdater(field) {
    return (value) => this.setState({[field]: value});
  }
  searchProducts() {
    console.log('In queryProducts');
    console.log(this.state.term);
    //return(value) => {
      //if (this.state.term){
        console.log('AJAX')
        $.ajax( {
          url: '/products/' + "?term=" + this.state.term, //+ "&collection=" + this.state.collection,
    	    dataType: 'json',
    	    success: function(data) {
    	      console.log('SUCCESS');
    	      console.log(data)
          this.setState({ products: data });
    	    }.bind(this),
    	    error: function(data) {
    	    }.bind(this)
    	   });
     //}
   // }
  }
}

class ProductIndexPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      term: 'cars',
      collection: null,
      products: this.props.products
    };
  }

  render() {
    function CreateItem(product) {
      return { 
        url: '/products/' + product.id, 
        attributeOne: product.title,
        attributeTwo: product.variants[0].variant_price,
        attributeThree: '5 prices from $8.99 to $13.99',
        // exceptions: [
        //   {
        //     status: 'warning',
        //     title: 'Not published to 2 channels',
        //     description: 'Content didn’t meet requirements for: Facebook, Amazon'
        //   },
        //   {
        //     status: 'warning',
        //     title: 'Missing weights on 1 variant',
        //     description: 'Calculated shipping rates won’t be accurate'
        //   }
        // ],
        // badges: [{content: product.has_active_price_test}, {content: 'Something'}, {content: 'Else'}],
        media: <Thumbnail
                  source={product.main_image_src}
                  alt={product.title}
                  size="small"
                />
      }
    }
    return (
      <Layout>
        <Layout.Section>
          <Card title="Online store dashboard" actions={[{content: 'Edit'}]} sectioned>
            <SearchTerms collections={this.props.collections} />
            <Card.Section>
                <ResourceList
                  items={
                      this.state.products.map(CreateItem)
                  }
                  renderItem={(item, index) => {
                    return <ResourceList.Item key={index} {...item} className='Polaris-Card' />;
                  }}
                />
            </Card.Section>
          </Card>
        </Layout.Section>
      </Layout>
    );
  }


  // searchProducts(field) {
  //   console.log('In queryProducts');
  //   console.log(this);
  //   console.log(this.state.value)
    
  //   return(value) => {
  //     if (value){
  //       $.ajax( {
  //         url: this.props.products_path + "?term=" + this.state.term, //+ "&collection=" + this.state.collection,
  //   	    dataType: 'json',
  //   	    success: function(data) {
  //         this.setState({ products: data });
  //   	    }.bind(this),
  //   	    error: function(data) {
  //   	    }.bind(this)
  //   	   });
  //     }
  //   }
  // }
}
  
document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('hello-react')
  const data = JSON.parse(node.getAttribute('data'))
ReactDOM.render(<ProductIndexPage {...data}/>, node)
})

    
    